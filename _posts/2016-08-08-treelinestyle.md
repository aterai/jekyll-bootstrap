---
layout: post
category: swing
folder: TreeLineStyle
title: JTreeのノード間の接続線のスタイルを変更する
tags: [JTree, MetalLookAndFeel]
author: aterai
pubdate: 2016-08-08T01:48:44+09:00
description: JTreeのノード間の接続線のスタイルを変更、または非表示にします。
image: https://drive.google.com/uc?id=1pbnpWXAOC1SNWnBA7miVxg8WiwCgX0w34w
comments: true
---
## 概要
`JTree`のノード間の接続線のスタイルを変更、または非表示にします。

{% download https://drive.google.com/uc?id=1pbnpWXAOC1SNWnBA7miVxg8WiwCgX0w34w %}

## サンプルコード
<pre class="prettyprint"><code>JTree tree0 = new JTree();
tree0.putClientProperty("JTree.lineStyle", "Angled");

JTree tree1 = new JTree();
tree1.putClientProperty("JTree.lineStyle", "Horizontal");

JTree tree2 = new JTree();
tree2.putClientProperty("JTree.lineStyle", "None");
</code></pre>

## 解説
上記のサンプルでは、`JTree#putClientProperty("JTree.lineStyle", "Angled");`などでノード間の接続線のスタイルを変更してます。この設定は`MetalLookAndFeel`を使用している場合のみ有効になります。

- `Angled`(`default`)
    - ノード間を接続する水平垂直線を表示する
    - デフォルト
- `Horizontal`
    - グループ(親)ノードの上下に水平線のみ表示する
- `None`
    - ノード間の接続線をすべて非表示にする

<!-- dummy comment line for breaking list -->

## 参考リンク
- [How to Use Trees (The Java™ Tutorials > Creating a GUI With JFC/Swing > Using Swing Components)](https://docs.oracle.com/javase/tutorial/uiswing/components/tree.html)
- [JTreeの水平垂直線を表示しない](https://ateraimemo.com/Swing/TreePaintLines.html)

<!-- dummy comment line for breaking list -->

## コメント
