---
layout: post
category: swing
folder: IconTitledBorder
title: TitledBorderのタイトルにアイコンを表示する
tags: [Border, TitledBorder, ImageIcon, Html]
author: aterai
pubdate: 2015-09-07T00:03:04+09:00
description: TitledBorderのタイトルに文字列だけでなく、アイコンを表示するように設定します。
image: https://lh3.googleusercontent.com/-CoxU1H7Z550/VexP9UAQdbI/AAAAAAAAOBI/QIVGOXu5MNE/s800-Ic42/IconTitledBorder.png
comments: true
---
## 概要
`TitledBorder`のタイトルに文字列だけでなく、アイコンを表示するように設定します。

{% download https://lh3.googleusercontent.com/-CoxU1H7Z550/VexP9UAQdbI/AAAAAAAAOBI/QIVGOXu5MNE/s800-Ic42/IconTitledBorder.png %}

## サンプルコード
<pre class="prettyprint"><code>URL url = getClass().getResource("16x16.png");
String path = url.toString();
String title = String.format(
  "&lt;html&gt;&lt;table cellpadding='0'&gt;&lt;tr&gt;&lt;td&gt;&lt;img src='%s'&gt;&lt;/td&gt;&lt;td&gt;test&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;/html&gt;", path);
panel.setBorder(BorderFactory.createTitledBorder(title));
</code></pre>

## 解説
- `<img>`
    - `TitledBorder#setTitle(...)`で`<img>`タグでアイコンを指定した`Html`テキストを設定
    - `Class#getResource(...)`でアイコンの`URL`を取得し、`<img>`のソースに指定
    - アイコンとテキストのベースラインが揃っていない
- `<table>` + `<img>`
    - `<table><tr>`タグを使用して、アイコンとテキストのベースラインを揃える
- `TitledBorder#paintBorder(...)`
    - `TitledBorder#paintBorder(...)`をオーバーライドしてアイコンを描画
    - タイトル文字列に半角空白で余白を作成し、位置を決め打ちでアイコンを描画
- `ComponentTitledBorder`
    - [BorderにJComponentを配置](https://ateraimemo.com/Swing/ComponentTitledBorder.html)からマウスリスナーなどを削除し、アイコンを追加した`JLabel`を適用

<!-- dummy comment line for breaking list -->

## 参考リンク
- [BorderにJComponentを配置](https://ateraimemo.com/Swing/ComponentTitledBorder.html)

<!-- dummy comment line for breaking list -->

## コメント
