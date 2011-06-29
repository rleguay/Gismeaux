CREATE TABLE patri.parkvdm
(
  affectation_2 character varying(10),
  bati_2 double precision,
  but_2 character varying(30),
  cod_budget character varying(2),
  codeinsee character varying(5),
  datact_2 date,
  datmanda date,
  exprop_2 character varying(30),
  fonction_b character varying(7),
  invar character varying(10),
  mandat_2 character varying(30),
  modeacqui_2 character varying(15),
  mouv_an character varying(2),
  natact_2 character varying(20),
  nature character varying(10),
  notaire_2 character varying(20),
  numbord character varying(7),
  numero_2 character varying(4),
  numordre character varying(6),
  numpiece character varying(8),
  observat_2 character varying(120),
  operation character varying(10),
  o0cleunik double precision,
  pacleunik double precision,
  section_2 character varying(2),
  superficie_2 double precision,
  transcrip_2 character varying(80),
  valacqui_2 double precision,
  valacqui_2_euro double precision
)
WITH (
  OIDS=TRUE
);

CREATE TABLE patri.origin
(
  affectation_2 character varying(10),
  bati_2 double precision,
  but_2 character varying(30),
  codeinsee character varying(5),
  datact_2 date,
  exprop_2 character varying(30),
  invar character varying(10),
  mandat_2 character varying(30),
  modeacqui_2 character varying(15),
  natact_2 character varying(20),
  notaire_2 character varying(20),
  numero_2 character varying(4),
  observat_2 character varying(120),
  o0cleunik double precision,
  o1cleunik double precision,
  recleunik double precision,
  section_2 character varying(2),
  superficie_2 double precision,
  transcrip_2 character varying(80),
  valacqui_2 double precision,
  valacqui_2_euro double precision
)
WITH (
  OIDS=TRUE
);

CREATE TABLE patri.regroup
(
  affectation_2 character varying(10),
  bati_2 double precision,
  but_2 character varying(30),
  codeinsee character varying(5),
  datact_2 date,
  exprop_2 character varying(30),
  invar character varying(10),
  mandat_2 character varying(30),
  modeacqui_2 character varying(15),
  natact_2 character varying(20),
  notaire_2 character varying(20),
  numero_2 character varying(4),
  observat_2 character varying(120),
  o0cleunik double precision,
  o1cleunik double precision,
  pacleunik double precision,
  recleunik double precision,
  r1cleunik double precision,
  section_2 character varying(2),
  superficie_2 double precision,
  transcrip_2 character varying(80),
  valacqui_2 double precision,
  valacqui_2_euro double precision
)
WITH (
  OIDS=TRUE
);


CREATE TABLE patri.vendu
(
  acquereur character varying(50),
  affectation_2 character varying(10),
  bati_2 double precision,
  but_2 character varying(30),
  codeinsee character varying(5),
  datact_2 date,
  daterecet date,
  datmanda date,
  datvente_2 date,
  exprop_2 character varying(30),
  invar character varying(10),
  mandat_2 character varying(30),
  modeacqui_2 character varying(15),
  mouv_an character varying(2),
  natact_2 character varying(20),
  notaire_2 character varying(20),
  notvente_2 character varying(20),
  numbord character varying(7),
  numbordv character varying(7),
  numero_2 character varying(4),
  numordre character varying(6),
  numordrev character varying(6),
  numpiece character varying(8),
  numpiecev character varying(8),
  observat_2 character varying(120),
  observat_3 character varying(120),
  o0cleunik double precision,
  section_2 character varying(2),
  superficie_2 double precision,
  transcrip_2 character varying(80),
  trans_vente_2 character varying(80),
  valacqui_2 double precision,
  valacqui_2_euro double precision,
  valvente_2 double precision,
  valvente_2_euro double precision,
  vecleunik double precision
)
WITH (
  OIDS=TRUE
);