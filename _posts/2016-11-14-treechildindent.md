---
layout: post
category: swing
folder: TreeChildIndent
title: JTreeのノードインデントを変更する
tags: [JTree, UIManager]
author: aterai
pubdate: 2016-11-14T02:01:08+09:00
description: JTreeのインデント量を指定して子ノードが描画される位置を変更します。
image: https://drive.google.com/uc?id=151DaTPRP49CvxXAWZMrKGyNaZqCo9IMDSA
comments: true
---
## 概要
`JTree`のインデント量を指定して子ノードが描画される位置を変更します。

{% download https://drive.google.com/uc?id=151DaTPRP49CvxXAWZMrKGyNaZqCo9IMDSA %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("Tree.leftChildIndent", 0);
UIManager.put("Tree.rightChildIndent", 0);
</code></pre>

## 解説
上記のサンプルでは、`JTree`の以下の`2`つインデント量を`UIManager.put(...)`で指定して子ノードが描画される位置を変更するテストを行っています。

- `Tree.leftChildIndent`
    - 親ノードの左端と垂直破線が描画される位置の間隔
- `Tree.rightChildIndent`
    - 垂直破線から子ノードが描画される位置の間隔

<!-- dummy comment line for breaking list -->

`Tree.leftChildIndent`と`Tree.rightChildIndent`の合計から子ノードのインデント量になるので、この合計が`0`になるように設定すると、デフォルトの`JList`風に各ノードを表示する`JTree`が作成可能です。

## 参考リンク
- [JTreeの展開、折畳みアイコンを非表示にする](https://ateraimemo.com/Swing/TreeExpandedIcon.html)
- [JTreeの水平垂直線を表示しない](https://ateraimemo.com/Swing/TreePaintLines.html)

<!-- dummy comment line for breaking list -->

## コメント
