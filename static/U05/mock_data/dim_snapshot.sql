-- dim_snapshot (3 rows)
DROP TABLE IF EXISTS bis242_00.willibald_ol_dm.dim_snapshot;
CREATE TABLE bis242_00.willibald_ol_dm.dim_snapshot (
  `hkey_dim_snapshot` STRING,
  `loadingdate` TIMESTAMP,
  `Summe von year` LONG,
  `Summe von month` LONG
);

INSERT INTO bis242_00.willibald_ol_dm.dim_snapshot VALUES
  ('c4ca4238a0b923820dcc509a6f75849b', TIMESTAMP '2022-03-12T00:00:00.000Z', 2022, 3),
  ('c81e728d9d4c2f636f067f89cc14862c', TIMESTAMP '2022-03-14T00:00:00.000Z', 2022, 3),
  ('eccbc87e4b5ce2fe28308fd9f2a7baf3', TIMESTAMP '2022-03-20T00:00:00.000Z', 2022, 3);
