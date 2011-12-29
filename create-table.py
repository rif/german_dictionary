from dal import DAL, Field
import re
db = DAL('sqlite://doxa.sqlite3')
db.define_table('dict',
                Field('word'),
                Field('definition'),
                Field('related'))

db.dict.truncate()
index = 0
for line in open("words_app.csv"):
    if line[0].isdigit() or line.startswith("#"): continue
    line = line.rstrip(",\n")
    line = line.split(",", 1)
    key, val = line[0], line[1]
    word = key
    if ')' in word:
        word = re.sub(r'\s*\(.+?\)\s*', '', word)
    db.dict.insert(word=word, definition=key, related=val)
    index += 1
db.commit()
print 'inserted %d words' % index
