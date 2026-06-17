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

-- Creates the edge OWNS.
CREATE TABLE `OWNS`(
  `URL` STRING(MAX) NOT NULL,
  `Developer` STRING(MAX) NOT NULL
) PRIMARY KEY (`Developer`, `URL`),
INTERLEAVE IN PARENT `Developer` ON DELETE CASCADE;

-- Adds a foreign key constraint to edge table IN_LANGUAGE to optimize forward edge traversal to its destination node Language.
ALTER TABLE `OWNS` ADD CONSTRAINT `FK_Repo_IN_REPO` FOREIGN KEY (`URL`) REFERENCES `Repo` (`URL`) NOT ENFORCED;

-- Creates a reverse edge index on edge table OWNS to optimize reverse edge traversal to source node Owns.
CREATE INDEX `IN_OWNS_ReverseIndex` ON `OWNS`(`URL`);

-- Creates the edge IN_LANGUAGE.
CREATE TABLE `IN_LANGUAGE`(
  `URL` STRING(MAX) NOT NULL,
  `Language` STRING(MAX) NOT NULL
) PRIMARY KEY (`URL`, `Language`),
INTERLEAVE IN PARENT `Repo` ON DELETE CASCADE;

-- Adds a foreign key constraint to edge table IN_LANGUAGE to optimize forward edge traversal to its destination node Language.
ALTER TABLE `IN_LANGUAGE` ADD CONSTRAINT `FK_Language_IN_LANGUAGE` FOREIGN KEY (`Language`) REFERENCES `Language` (`Language`) NOT ENFORCED;

-- Creates a reverse edge index on edge table IN_LANGUAGE to optimize reverse edge traversal to source node Language.
CREATE INDEX `IN_LANGUAGE_ReverseIndex` ON `IN_LANGUAGE` (`Language`), INTERLEAVE IN `Language`;

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
      ),
    -- Added the Developer node table so the OWNS edge has a valid source
    `Developer` KEY(`Developer`)
      LABEL `Developer` PROPERTIES (
        `Developer`
      )
  )
  EDGE TABLES (
    `IN_LANGUAGE` KEY (`URL`, `Language`)
      SOURCE KEY (`URL`) REFERENCES `Repo` (`URL`)
      DESTINATION KEY (`Language`) REFERENCES `Language` (`Language`)
      LABEL `IN_LANGUAGE` PROPERTIES (
        `URL`,
        `Language`
      ),
    -- Added the new OWNS edge table
    `OWNS` KEY (`Developer`, `URL`)
      SOURCE KEY (`Developer`) REFERENCES `Developer` (`Developer`)
      DESTINATION KEY (`URL`) REFERENCES `Repo` (`URL`)
      LABEL `OWNS` PROPERTIES (
        `Developer`,
        `URL`
      )
  );
