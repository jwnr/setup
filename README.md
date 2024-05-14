## PCセットアップ
```
## セットアップ [root実行 ※sudoではなく]
curl -sL s.jwnr.net/mjr-i3 | sh


## ドットファイルデプロイ [ユーザー実行]
curl -sL d.jwnr.net | sh
```

<br><br>


## FWセットアップ

|  | npm |  | bun |  |
|:-|:-|:-|:-|:-|
| Astro       | npm create astro@latest      | [Astro](https://astro.build/)                   | bun create astro             | [Bun-Guide](https://bun.sh/guides/ecosystem/astro)     |
| SvelteKit   | npm create svelte@latest xxx | [SvelteKit](https://kit.svelte.dev/)            | bun create svelte@latest xxx | [Bun-Guide](https://bun.sh/guides/ecosystem/sveltekit) |
| Next.js     | npx create-next-app@latest   | [Next.js](https://nextjs.org/)                  | bun create next-app          | [Bun-Guide](https://bun.sh/guides/ecosystem/nextjs)    |
| hono        | npm create hono@latest xxx   | [Hono](https://hono.dev/getting-started/nodejs) | bun create hono xxx          | [Hono](https://hono.dev/getting-started/bun)<br>[Bun-Guide](https://bun.sh/guides/ecosystem/hono)  |
| Drizzle ORM |      | [Drizzle](https://orm.drizzle.team/) |      | [Drizzle](https://orm.drizzle.team/docs/get-started-sqlite#bun-sqlite)<br>[Bun-Guide](https://bun.sh/guides/ecosystem/drizzle)  |
| Prisma |      | [Prisma](https://www.prisma.io/) |      | [Prisma](https://www.prisma.io/docs/orm/tools/prisma-cli#bun)<br>[Bun-Guide](https://bun.sh/guides/ecosystem/prisma)  |


<br><br>


## Bun workspaces (モノレポ)
```
#### ディレクトリ構造
<root>
├ packages/      <--- pckgs, prjs, apps, etc...
│  ├ aaa         <-┐
│  ├ bbb         <-┴- package directorys
│  └ ...
├ bun.lockb
├ ...
├ package.json   <--- ## 要編集 ##
└ ...



#### <root>/package.json
{
  "name": "monorepo"
  ...
  "workspaces": [      <-┐
    "packages/*"       <-┼- 追記
  ],                   <-┘
  ...
}



#### <root>/packages/aaa/package.json
{
  "name": "aaa"      <--- 必須
  ...
}


```

<br><br>


## Bun テスト
+ jest に相当するのかな (jestから移行可能)
+ モック
  - スパイ
+ スナップショット
+ DOMの要素を取得するテストでは happy-dom(jsdom) が必要 ( bun add -D happy-dom ??? )
+ vite.config.ts で globals: true を書かなくても、 test,describe,expect 等の import が効く?


## コマンド
```
## 基本
bun test

## 特定 (/test/xxxx.test.js)
bun test xxxx

## 特定 (テストファイル内の関数)
bun test -t xxxx

##
bun test --coverage



--watch    変更検知 & テストrun
--bail     １つのエラーで即停止
--bail 4   ４つの...
--timeout 
--rerun
```

## コード
```
## describe
関連するテストをグループ化


## it, test
テスト


## beforeAll / afterAll
テスト実行前/後に一度だけ実行


## beforeEach / afterEach
各テストの前/後に都度実行



#### 基本
#########################
import { expect, test } from "bun:test";

test("テスト名", () => {
  // 一致すれば pass
  expect(2 + 2).toBe(4);

  // 一致しなければ pass
  expect(2 + 2).not.toBe(4);
});


#### 条件分岐
#########################
est.if(Math.random() > 0.5)("runs half the time", () => {
  // ...
});

const macOS = process.arch === "darwin";
test.if(macOS)("runs on macOS", () => {
  // runs if macOS
});
test.skipIf(macOS)("runs on non-macOS", () => {
  // runs if *not* macOS
});


#### 非同期通信 (or promiseの待機)
#########################
import { expect, test } from "bun:test";

test("2 * 2", async () => {
  const result = await Promise.resolve(2 * 2);
  expect(result).toEqual(4);
});

test("2 * 2", done => {
  Promise.resolve(2 * 2).then(result => {
    expect(result).toEqual(4);
    done();
  });
});


#### タイムアウト
#########################
import { test } from "bun:test";

test("wat", async () => {
  const data = await slowOperation();
  expect(data).toBe(42);
}, 500); // test must run in <500ms



//==== あんま使わないかな
//test.todoIf(...)(...)
//describe.todoIf(...)(...)


//==== 未実装の部分を書いとく
test.todo("コメント")




# 未実装の部分を書いとく
test.todo("コメント")

# 使いどころがよくわからん
test.skip("asdfasdf", ()=>{...})

```

<br><br>


## Svelte, Sveltekit


#### /src/app.html
```
<html lang="en">
  ↓
<html lang="ja">

<meta name="author" content="xxxx">

```


#### /src/routes/xxx.svelte
```
<svelte:head>
  <title>タイトル</title>
  <meta name="description" content="説明">
  <meta name="keywords" content="キーワード(もうほぼ不要)">
</svelte:head>

```

<br><br>


## Bun + Sveltekit

> bun add -D svelte-adapter-bun

#### /svelte.config.js
```
- import adapter from "@sveltejs/adapter-auto";
+ import adapter from "svelte-adapter-bun";
  import { vitePreprocess } from "@sveltejs/kit/vite";   <- これはTS使用時のみ??
  
  /** @type {import('@sveltejs/kit').Config} */
  const config = {
    kit: {
      adapter: adapter(),
    },
    preprocess: vitePreprocess(),   <- これはTS使用時のみ??
  };

```





