CREATE DATABASE linguistic_db;
USE linguistic_db;

CREATE TABLE languages (
    language_id INT PRIMARY KEY,
    language_name VARCHAR(100)
);

CREATE TABLE phonemes (
    phoneme_id INT PRIMARY KEY,
    language_id INT,
    symbol VARCHAR(10),
    ipa VARCHAR(20),
    description TEXT,
    place_of_articulation VARCHAR(100),
    manner_of_articulation VARCHAR(100),
    voicing VARCHAR(20),
    FOREIGN KEY (language_id) REFERENCES languages(language_id)
);

CREATE TABLE grammemes (
    grammeme_id INT PRIMARY KEY,
    language_id INT,
    part_of_speech VARCHAR(50),
    category VARCHAR(100),
    value VARCHAR(100),
    FOREIGN KEY (language_id) REFERENCES languages(language_id)
);

CREATE TABLE examples (
    example_id INT PRIMARY KEY,
    phoneme_id INT,
    word VARCHAR(100),
    FOREIGN KEY (phoneme_id) REFERENCES phonemes(phoneme_id)
);

INSERT INTO languages (language_id, language_name) VALUES
(1, 'English'),
(2, 'Russian');

INSERT INTO phonemes (phoneme_id, language_id, symbol, ipa, description, place_of_articulation, manner_of_articulation, voicing) VALUES
(1, 1, 'p', '/p/', 'Voiceless bilabial stop', 'Bilabial', 'Stop', 'Voiceless'),
(2, 1, 'd', '/d/', 'Voiced alveolar stop', 'Alveolar', 'Stop', 'Voiced'),
(3, 2, 'б', '/b/', 'Voiced bilabial stop', 'Bilabial', 'Stop', 'Voiced'),
(4, 2, 'ш', '/ʂ/', 'Voiceless retroflex fricative', 'Postalveolar', 'Fricative', 'Voiceless');

INSERT INTO examples (example_id, phoneme_id, word) VALUES
(1, 1, 'pen'),
(2, 1, 'apple'),
(3, 2, 'dog'),
(4, 3, 'брат'),
(5, 4, 'школа');

INSERT INTO grammemes (grammeme_id, language_id, part_of_speech, category, value) VALUES
(1, 1, 'Noun', 'Number', 'Singular'),
(2, 1, 'Noun', 'Case', 'Nominative'),
(3, 2, 'Noun', 'Number', 'Множественное'),
(4, 2, 'Noun', 'Case', 'Творительный');

UPDATE phonemes
SET description = 'Voiceless postalveolar fricative'
WHERE symbol = 'ш';

SELECT symbol, ipa FROM phonemes WHERE language_id = 2;

SELECT category, value FROM grammemes WHERE language_id = 1 AND part_of_speech = 'Noun';

SELECT e.word, p.ipa, l.language_name
	FROM examples e
	JOIN phonemes p ON e.phoneme_id = p.phoneme_id
	JOIN languages l ON p.language_id = l.language_id;

SELECT p.symbol, p.description
	FROM phonemes p
	JOIN languages l ON p.language_id = l.language_id
	WHERE p.manner_of_articulation = 'Stop' AND l.language_name = 'English';

DELETE FROM examples WHERE word = 'dog';