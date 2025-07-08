use("HW2");

// коллекция с языками
db.languages.insertMany([
  { _id: 1, language_name: "English" },
  { _id: 2, language_name: "Russian" }
]);

// коллекция с фонемами
db.phonemes.insertMany([
  {
    _id: 1,
    language_id: 1,
    symbol: "p",
    ipa: "/p/",
    description: "Voiceless bilabial stop",
    place_of_articulation: "Bilabial",
    manner_of_articulation: "Stop",
    voicing: "Voiceless"
  },
  {
    _id: 2,
    language_id: 1,
    symbol: "d",
    ipa: "/d/",
    description: "Voiced alveolar stop",
    place_of_articulation: "Alveolar",
    manner_of_articulation: "Stop",
    voicing: "Voiced"
  },
  {
    _id: 3,
    language_id: 2,
    symbol: "б",
    ipa: "/b/",
    description: "Voiced bilabial stop",
    place_of_articulation: "Bilabial",
    manner_of_articulation: "Stop",
    voicing: "Voiced"
  },
  {
    _id: 4,
    language_id: 2,
    symbol: "ш",
    ipa: "/ʂ/",
    description: "Voiceless retroflex fricative",
    place_of_articulation: "Postalveolar",
    manner_of_articulation: "Fricative",
    voicing: "Voiceless"
  }
]);

// коллекция с примерами
db.examples.insertMany([
  { _id: 1, phoneme_id: 1, word: "pen" },
  { _id: 2, phoneme_id: 1, word: "apple" },
  { _id: 3, phoneme_id: 2, word: "dog" },
  { _id: 4, phoneme_id: 3, word: "брат" },
  { _id: 5, phoneme_id: 4, word: "школа" }
]);

// коллекция с граммемами
db.grammemes.insertMany([
  { _id: 1, language_id: 1, part_of_speech: "Noun", category: "Number", value: "Singular" },
  { _id: 2, language_id: 1, part_of_speech: "Noun", category: "Case", value: "Nominative" },
  { _id: 3, language_id: 2, part_of_speech: "Noun", category: "Number", value: "Множественное" },
  { _id: 4, language_id: 2, part_of_speech: "Noun", category: "Case", value: "Творительный" }
]);

// изменение описания фонемы 
db.phonemes.updateOne(
  { symbol: "ш" },
  { $set: { description: "Voiceless postalveolar fricative" } }
);

// простой запрос 1: все русские фонемы
db.phonemes.find({ language_id: 2 }, { symbol: 1, ipa: 1, _id: 0 });

// простой запрос 2: все английские граммемы (сущ.))
db.grammemes.find({ language_id: 1, part_of_speech: "Noun" });

// составной запрос 1: примеры слов с IPA и языком
db.examples.aggregate([
  {
    $lookup: {
      from: "phonemes",
      localField: "phoneme_id",
      foreignField: "_id",
      as: "phoneme"
    }
  },
  { $unwind: "$phoneme" },
  {
    $lookup: {
      from: "languages",
      localField: "phoneme.language_id",
      foreignField: "_id",
      as: "language"
    }
  },
  { $unwind: "$language" },
  {
    $project: {
      _id: 0,
      word: 1,
      ipa: "$phoneme.ipa",
      language_name: "$language.language_name"
    }
  }
]);

// составной запрос 2: все английские stop-фонемы
db.phonemes.aggregate([
  {
    $match: {
      manner_of_articulation: "Stop"
    }
  },
  {
    $lookup: {
      from: "languages",
      localField: "language_id",
      foreignField: "_id",
      as: "lang"
    }
  },
  { $unwind: "$lang" },
  {
    $match: { "lang.language_name": "English" }
  },
  {
    $project: {
      symbol: 1,
      description: 1,
      _id: 0
    }
  }
]);

// решил удалить собаку, потому что я — cat person
db.examples.deleteOne({ word: "dog" });