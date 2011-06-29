CREATE OR REPLACE FUNCTION cadastre.gm_desc_parcelle(ref character varying, droit character varying)
  RETURNS text AS
$BODY$declare
ligne RECORD;
rivoli RECORD;
compteur RECORD;
cprop RECORD;
chaine text;
prop text;
bati text;
begin
select * into ligne from cadastre.parcel where ind in ( ref );
select nom_voie into rivoli from cadastre.voies where code_voie = ligne.ccoriv and commune=ligne.commune;
select count(*) as cpt into compteur from cadastre.pdlasdgi where commune like ligne.commune and ccosec like ligne.ccosec and dnupla like ligne.dnupla;
select dnuper into cprop from cadastre.propriet where commune like ligne.commune and cgroup like ligne.cgroup and dnumcp like ligne.dnumcp;
if ligne.gpdl='0' or(ligne.gpdl='1' and compteur.cpt='0') then
	if ligne.gparbat='1' then
		chaine := '<tr><td colspan="4" align="center" class="tt1">Fiche d''une parcelle b&acirc;tie ';
		bati := '<tr><td colspan="4" align="center" class="tt2">';
		if ligne.cgroup='*' then
			bati := bati||'Co-propri&eacute;taire</td></tr>';
			bati := bati||cadastre.gm_liste_copro(ligne.commune,ligne.ccosec,ligne.dnupla,droit);
		else
			bati := bati||'Locaux</td></tr>';
			bati := bati||cadastre.gm_liste_bati(ligne.commune,ligne.ccosec,ligne.dnupla,droit);
		end if;
	else
		chaine = '<tr><td colspan="4" align="center" class="tt1">Fiche d''une parcelle non b&acirc;tie ';
	end if;
	chaine := chaine||'<img src="../../doc_commune/770284/skins/sig.png" onclick="window.opener.parent.svgWin.cadreparcelle('''||ligne.ind||''')" alt="cadrer sur le SIG" align="right"/></td></td></tr><tr><td>Section</td>';
	chaine := chaine||'<td>'||ligne.ccosec||'</td><td>Numero</td><td>'||ligne.dnupla||'</td></tr><tr><td>Adresse</td>';
	chaine := chaine||'<td colspan="3">'||public.gm_sinul(ligne.dnuvoi,' ')||public.gm_sinul(ligne.dindic,' ')||', '||public.gm_sinul(rivoli.nom_voie,' ');
	chaine := chaine||'</td></tr><tr><td>Contenance</td><td>'||ligne.dcntpa||'</td><td>Date de l''acte</td><td>'||ligne.jdatat||'</td></tr><tr>';
--attention code correspondant a la ville de Meaux à rendre adaptable 
	if (cprop.dnuper ='PBCX3B' or cprop.dnuper = 'PBDWPL') and (droit='h' or droit = 'a') then
		chaine := chaine||'<td colspan="4" align="center" class="tt2">Propri&eacute;t&eacute; Ville de Meaux</td></tr>';
		chaine := chaine||cadastre.gm_hypothec(ligne.commune,ligne.ccosec,ligne.dnupla,ligne.dparpi);
	else
		chaine := chaine||'<td colspan="4" align="center" class="tt2">Propri&eacute;taire</td></tr>';
		chaine := chaine||cadastre.gm_liste_proprietaire(ligne.commune,ligne.cgroup,ligne.dnumcp);
	end if;
	if ligne.gparbat='1' then 
	  chaine=chaine||bati;
	end if;
else
	chaine := '';
	if ligne.gpdl='1' then
		chaine := chaine||cadastre.gm_terr_ass(ligne.commune,ligne.ccosec,ligne.dnupla, droit);
	else
		chaine := chaine||cadastre.gm_terr_ass(ligne.commune,ligne.ccosecr,ligne.dnuplar, droit);
	end if;
end if;
return chaine;
end
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION cadastre.gm_desc_parcelle(character varying, character varying) OWNER TO sig;

CREATE OR REPLACE FUNCTION cadastre.gm_hypothec(comm character varying, section character varying, numero character varying, dparpi character varying)
  RETURNS text AS
$BODY$declare
pkvdm RECORD;
orig RECORD;
chaine text;
numer character varying;
dpar character varying;
begin
numer=(numero::integer)::character varying;
select * into pkvdm from patri.parkvdm where section_2||numero_2 like section||numer;
if FOUND then
	chaine := '<tr><td>Date de l''acte : <INPUT type="text" value="'||gm_sinul(pkvdm.datact_2::text,'')||'" readonly></td>';
	chaine := chaine|| '<td>Mode acquisition : <INPUT type="text" value="'||pkvdm.modeacqui_2||'" readonly></td></tr>';
	chaine := chaine|| '<tr><td>Nature de l''acte : <INPUT type="text" value="'||pkvdm.natact_2||'" readonly></td>';
	chaine := chaine|| '<td>Notaire : <INPUT type="text" value="'||pkvdm.notaire_2||'" readonly></td>';
	chaine := chaine|| '<td>Transcription : <INPUT type="text" value="'||pkvdm.transcrip_2||'" size="40" readonly></td></tr>';
	chaine := chaine||'<tr><td colspan=3>But de l''achat : <INPUT type="text" value="'||pkvdm.but_2||'" size="80" readonly></td></tr>';
	chaine := chaine|| '<tr><td>Ex-propriétaire : <INPUT type="text" value="'||pkvdm.exprop_2||'" readonly></td></tr>';
	chaine := chaine|| '<tr><td>Numéro mandat : <INPUT type="text" value="'||pkvdm.mandat_2||'" readonly></td>';
	chaine := chaine|| '<td>Valeur d''acquisition : <INPUT type="text" value="'||pkvdm.valacqui_2||'F" readonly></td>';
	chaine := chaine|| '<td>Valeur d''acquisition : <INPUT type="text" value="'||pkvdm.valacqui_2_euro||'€" readonly></td></tr>';
	chaine := chaine|| '<tr><td colspan=2>Observations : <INPUT type="text" value="'||pkvdm.observat_2||'" size="80" readonly></td></tr>';
	if ((pkvdm.o0cleunik::text <> '') and (pkvdm.o0cleunik::text <> '0')) then
           chaine := chaine || cadastre.gm_origin(pkvdm.o0cleunik);
	end if;
	select count(*) as cpt into orig from patri.regroup where pacleunik = pkvdm.pacleunik;
	if orig.cpt::integer > 0 then
	   chaine := chaine ||cadastre.gm_regroup(pkvdm.pacleunik);
	end if;
else
	chaine := '<tr><td>Parcelle provenant de '||section||dparpi||'</td></tr>';
	dpar = (dparpi::integer)::character varying;
	select * into pkvdm from patri.parkvdm where section_2||numero_2 like section||dpar;
	if FOUND then
		chaine := chaine|| '<tr><td>Date de l''acte : <INPUT type="text" value="'||pkvdm.datact_2||'" readonly></td>';
		chaine := chaine|| '<td>Mode acquisition : <INPUT type="text" value="'||pkvdm.modeacqui_2||'" readonly></td></tr>';
		chaine := chaine|| '<tr><td>Nature de l''acte : <INPUT type="text" value="'||pkvdm.natact_2||'" readonly></td>';
		chaine := chaine|| '<td>Notaire : <INPUT type="text" value="'||pkvdm.notaire_2||'" readonly></td>';
		chaine := chaine|| '<td>Transcription : <INPUT type="text" value="'||pkvdm.transcrip_2||'" readonly></td></tr>';
		chaine := chaine||'<tr><td colspan=3>But de l''achat : <INPUT type="text" value="'||pkvdm.but_2||'" readonly></td></tr>';
		chaine := chaine|| '<tr><td>Ex-propriétaire : <INPUT type="text" value="'||pkvdm.exprop_2||'" readonly></td></tr>';
		chaine := chaine|| '<tr><td>Numéro mandat : <INPUT type="text" value="'||pkvdm.mandat_2||'" readonly></td>';
		chaine := chaine|| '<td>Valeur d''acquisition : <INPUT type="text" value="'||pkvdm.valacqui_2||'F" readonly></td>';
		chaine := chaine|| '<td>Valeur d''acquisition : <INPUT type="text" value="'||pkvdm.valacqui_2_euro||'€" readonly></td></tr>';
		chaine := chaine|| '<tr><td colspan=2>Observations : <INPUT type="text" value="'||pkvdm.observat_2||'" readonly></td></tr>';
	end if;
end if;
return chaine;
end;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION cadastre.gm_hypothec(character varying, character varying, character varying, character varying) OWNER TO sig;



CREATE OR REPLACE FUNCTION cadastre.gm_origin(ooo double precision)
  RETURNS text AS
$BODY$declare
orig RECORD;
chaine text;
begin
   select * into orig from patri.origin where o0cleunik = ooo;
   chaine :='';
   if FOUND then
      chaine := chaine|| '<tr><td colspan=3><table>';
      chaine := chaine|| '<tr><td rowspan=8>Provient de la division de :</td><td>'||orig.section_2||orig.numero_2||'</td><td>contenance : '||orig.superficie_2||' m²</td></tr>';
      chaine := chaine|| '<tr><td>Date de l''acte : <INPUT type="text" value="'||orig.datact_2||'" readonly></td>';
      chaine := chaine|| '<td>Mode acquisition : <INPUT type="text" value="'||orig.modeacqui_2||'" readonly></td></tr>';
      chaine := chaine|| '<tr><td>Nature de l''acte : <INPUT type="text" value="'||orig.natact_2||'" readonly></td>';
      chaine := chaine|| '<td>Notaire : <INPUT type="text" value="'||orig.notaire_2||'" readonly></td>';
      chaine := chaine|| '<td>Transcription : <INPUT type="text" value="'||orig.transcrip_2||'" size="40" readonly></td></tr>';
      chaine := chaine||'<tr><td colspan=3>But de l''achat : <INPUT type="text" value="'||orig.but_2||'" size="80" readonly></td></tr>';
      chaine := chaine|| '<tr><td>Ex-propriétaire : <INPUT type="text" value="'||orig.exprop_2||'" readonly></td></tr>';
      chaine := chaine|| '<tr><td>Numéro mandat : <INPUT type="text" value="'||orig.mandat_2||'" readonly></td>';
      chaine := chaine|| '<td>Valeur d''acquisition : <INPUT type="text" value="'||orig.valacqui_2||'F" readonly></td>';
      chaine := chaine|| '<td>Valeur d''acquisition : <INPUT type="text" value="'||orig.valacqui_2_euro||'€" readonly></td></tr>';
      chaine := chaine|| '<tr><td colspan=2>Observations : <INPUT type="text" value="'||orig.observat_2||'" size="80" readonly></td></tr>';
	if ((orig.recleunik::text <> '') and (orig.recleunik::text <> '0')) then
		chaine := chaine || cadastre.gm_regroup(orig.recleunik);
	end if;
      chaine := chaine|| '</table></td></tr>';
  end if;
return chaine;
end;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION cadastre.gm_origin(double precision) OWNER TO sig;


CREATE OR REPLACE FUNCTION cadastre.gm_regroup(clef double precision)
  RETURNS text AS
$BODY$declare
orig RECORD;
chaine text;
begin
   chaine :='';
   chaine := chaine|| '<tr><td colspan=3><table>';
   for orig in select * from patri.regroup where pacleunik = clef order by section_2||numero_2 loop
      chaine := chaine|| '<tr><td rowspan=7>Provient du regroupement de :</td><td>'||orig.section_2||orig.numero_2||'</td><td>contenance : '||orig.superficie_2||' m²</td></tr>';
      chaine := chaine|| '<tr><td>Date de l''acte : <INPUT type="text" value="'||orig.datact_2||'" readonly></td>';
      chaine := chaine|| '<td>Mode acquisition : <INPUT type="text" value="'||orig.modeacqui_2||'" readonly></td></tr>';
      chaine := chaine|| '<tr><td>Nature de l''acte : <INPUT type="text" value="'||orig.natact_2||'" readonly></td>';
      chaine := chaine|| '<td>Notaire : <INPUT type="text" value="'||orig.notaire_2||'" readonly></td>';
      chaine := chaine|| '<td>Transcription : <INPUT type="text" value="'||orig.transcrip_2||'" size="40" readonly></td></tr>';
      chaine := chaine||'<tr><td colspan=3>But de l''achat : <INPUT type="text" value="'||orig.but_2||'" size="80" readonly></td></tr>';
      chaine := chaine|| '<tr><td>Ex-propriétaire : <INPUT type="text" value="'||orig.exprop_2||'" readonly></td></tr>';
      chaine := chaine|| '<tr><td>Numéro mandat : <INPUT type="text" value="'||orig.mandat_2||'" readonly></td>';
      chaine := chaine|| '<td>Valeur d''acquisition : <INPUT type="text" value="'||orig.valacqui_2||'F" readonly></td>';
      chaine := chaine|| '<td>Valeur d''acquisition : <INPUT type="text" value="'||orig.valacqui_2_euro||'€" readonly></td></tr>';
      chaine := chaine|| '<tr><td colspan=2>Observations : <INPUT type="text" value="'||orig.observat_2||'" size="80" readonly></td></tr>';
	--if ((orig.recleunik::text <> '') and (orig.recleunik::text <> '0')) then
	--	chaine := chaine || cadastre.gm_regroup(orig.recleunik);
	--end if;
  end loop;
  chaine := chaine|| '</table></td></tr>';
return chaine;
end;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION cadastre.gm_regroup(double precision) OWNER TO sig;

