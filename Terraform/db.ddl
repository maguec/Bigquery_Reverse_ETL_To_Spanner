-- Creates the node Repo.
CREATE TABLE `Repo`(
  `URL` STRING(MAX) NOT NULL,
  `Name` STRING(MAX) NOT NULL,
  `Public` BOOL NOT NULL,
  `CreationDate` TIMESTAMP NOT NULL
) PRIMARY KEY (`URL`);

-- Creates the node Language.
CREATE TABLE `Language`(
  `Language` STRING(MAX) NOT NULL
) PRIMARY KEY (`Language`);

-- Creates the node Developer.
CREATE TABLE `Developer`(
  `Developer` STRING(MAX) NOT NULL
) PRIMARY KEY (`Developer`);

-- Creates the edge IN_LANGUAGE.
CREATE TABLE `IN_LANGUAGE`(
  `URL` STRING(MAX) NOT NULL,
  `Language` STRING(MAX) NOT NULL
) PRIMARY KEY (`URL`, `Language`),
INTERLEAVE IN PARENT `Repo` ON DELETE CASCADE;

-- Adds a foreign key constraint to edge table IN_LANGUAGE to optimize forward edge traversal to its destination node Language.
ALTER TABLE `IN_LANGUAGE` ADD CONSTRAINT `FK_Language_IN_LANGUAGE` FOREIGN KEY (`Language`) REFERENCES `Language` (`Language`) NOT ENFORCED;

-- Creates or updates the property graph Github
CREATE OR REPLACE PROPERTY GRAPH `Github`
  NODE TABLES (
    `Repo` KEY(`URL`)
      LABEL `Repo` PROPERTIES (
        `URL`,
        `Name`,
        `Public`,
        `CreationDate`
      ),
    `Language` KEY(`Language`)
      LABEL `Language` PROPERTIES (
        `Language`
      )
  )
  EDGE TABLES (
    `IN_LANGUAGE` KEY (`URL`, `Language`)
      SOURCE KEY (`URL`) REFERENCES `Repo` (`URL`)
      DESTINATION KEY (`Language`) REFERENCES `Language` (`Language`)
      LABEL `IN_LANGUAGE` PROPERTIES (
        `URL`,
        `Language`
      )
  );

-- Creates a reverse edge index on edge table IN_LANGUAGE to optimize reverse edge traversal to source node Language.
CREATE INDEX `IN_LANGUAGE_ReverseIndex`
ON `IN_LANGUAGE` (`Language`),
INTERLEAVE IN `Language`;
