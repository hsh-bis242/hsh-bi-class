-- dim_association (23 rows)
DROP TABLE IF EXISTS bis242_00.willibald_ol_dm.dim_association;
CREATE TABLE bis242_00.willibald_ol_dm.dim_association (
  `hkey_dim_association` STRING,
  `association_name` STRING,
  `discount1` LONG,
  `discount2` LONG,
  `discount3` LONG
);

INSERT INTO bis242_00.willibald_ol_dm.dim_association VALUES
  ('8ca77c7832f573130f68ba99225b7357', 'Abendröte', 2, 3, 6),
  ('8cbe864857c636ab8f99cd9acf14fd3d', 'Abendröte', 2, 3, 6),
  ('29d9dc95c6908dcfb518982a378a32bf', 'Blaetterglueck', 4, 8, 16),
  ('69283fd5510ff1d9eb14c08763c541da', 'Blaetterglueck', 4, 8, 16),
  ('b3b5806134b22221df45b38d71497a8d', 'Blaetterglueck', 4, 8, 16),
  ('0a19a57f278983cd110daf270ae8a0ec', 'Druff1848', 3, 6, 12),
  ('0c7744b319a17344ef450b2852cd767e', 'Druff1848', 3, 6, 12),
  ('1a956ce947d2b75971ce12abf6ee47fe', 'Druff1848', 3, 6, 12),
  ('6e6975f45dc4f2e417106c0e2d1bec66', 'GlückAuf', 2, 4, 8),
  ('b892821fe7ecd29497aac03f6c48d172', 'GlückAuf', 2, 4, 8),
  ('ef9c77666780809f7616b919fed771ec', 'GlückAuf', 2, 4, 8),
  ('b2aa39400faa0867e4b0cf54c5b2d0e3', 'Morgenstern', 3, 6, 12),
  ('74668fcd4ea1b014354c0d3d93709d2c', 'No association', NULL, NULL, NULL),
  ('a9fbb20c0413646fc2818534c827b3e8', 'No association', NULL, NULL, NULL),
  ('b82c6014484453a40554f217f8c20eb2', 'No association', NULL, NULL, NULL),
  ('1d2d0f84069c8dca20aae36e641673f4', 'Ruhrmorig', 3, 6, 12),
  ('e11623cc753a087a46f30e0db9fab785', 'Ruhrmorig', 3, 6, 12),
  ('1de502e60246da6f25526a94bdde4374', 'VolleRose', 1, 2, 4),
  ('b489bbd83105821bbeca6c70803079d8', 'VolleRose', 1, 2, 4),
  ('924139a86e60d081cd00ffb789b15b35', 'VolleRose', 1, 2, 5),
  ('0f388e8d35d2fcb0befef1c58697c793', 'WochenendGLück', 5, 10, 18),
  ('84d92e19aae2aa7a9d3e3ab2c9903af4', 'WochenendGLück', 5, 10, 18),
  ('d6faccec1fc9cc858b906be69469f7b4', 'WochenendGLück', 5, 10, 18);
