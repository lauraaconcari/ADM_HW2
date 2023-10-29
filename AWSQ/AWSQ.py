import time
import pandas as pd

start = time.time()
df_chunks =  pd.read_json('list.json', lines=True, chunksize=100)

ftags = {}
for chunk in df_chunks:
    chunk = chunk['tags'].apply(lambda x: x if x != [] else None).dropna()
    for taglist in chunk:
        for tag in taglist:
            ftags[tag] = ftags.get(tag, 0) + 1

sorted_tags = sorted(ftags.items(), key=lambda x: x[1], reverse=True)
df = pd.DataFrame(sorted_tags[:5], columns=['tag', '#usage'])
df.set_index('tag', inplace=True)

print(f"Time of execution: {time.time() - start} seconds")