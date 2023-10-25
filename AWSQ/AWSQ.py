import time
import pandas as pd

start = time.time()
df_chunks =  pd.read_json('list.json', lines=True, chunksize=100)

tags = {}
for chunk in df_chunks:
    chunk = chunk.dropna(subset=['tags'])
    for tag in chunk['tags']:
        if tag != []:
            for i in tag:
                if i in tags.keys():
                    tags[i] +=1
                else:
                    tags[i] = 1

sorted_tags = sorted(tags.items(), key=lambda x: x[1], reverse=True)
df = pd.DataFrame(sorted_tags[:5], columns=['tag', '#usage'])
df.set_index('tag', inplace=True)

print(f"Time elapsed: {time.time() - start} seconds")