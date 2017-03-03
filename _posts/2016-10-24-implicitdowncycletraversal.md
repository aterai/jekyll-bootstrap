---
layout: post
category: swing
folder: ImplicitDownCycleTraversal
title: FocusTraversalPolicyの自動的なフォーカスダウンサイクルを無効にする
tags: [Focus, FocusTraversalPolicy]
author: aterai
pubdate: 2016-10-24T00:34:35+09:00
description: SortingFocusTraversalPolicyを設定したパネルで、暗黙的にフォーカスをダウンサイクルで移動しないように設定します。
image: https://drive.google.com/uc?export=view&id=1BhqefPKEKZ7kqrsjy2ySEncqitLXR7qrfw
comments: true
---
## 概要
`SortingFocusTraversalPolicy`を設定したパネルで、暗黙的にフォーカスをダウンサイクルで移動しないように設定します。

{% download https://drive.google.com/uc?export=view&id=1BhqefPKEKZ7kqrsjy2ySEncqitLXR7qrfw %}

## サンプルコード
<pre class="prettyprint"><code>JPanel p = new JPanel();
LayoutFocusTraversalPolicy ftp = new LayoutFocusTraversalPolicy();
ftp.setImplicitDownCycleTraversal(false);
p.setFocusCycleRoot(true);
p.setFocusTraversalPolicy(ftp);
</code></pre>

## 解説
上記のサンプルでは、`SortingFocusTraversalPolicy#setImplicitDownCycleTraversal(...)`で、暗黙的にフォーカスをダウンサイクルで移動するかどうかを切り替えて、子パネルへのフォーカス移動のテストを行っています。

- `SortingFocusTraversalPolicy#setImplicitDownCycleTraversal(true)`
    - デフォルト
    - デフォルトフォーカスの`JCheckBox`から、<kbd>Tab</kbd>キーで子パネル内の`JTextArea`にダウンサイクルでフォーカスが移動可能
- `SortingFocusTraversalPolicy#setImplicitDownCycleTraversal(false)`
    - 子パネルが`setFocusCycleRoot(true)`の場合、デフォルトフォーカスの`JCheckBox`から<kbd>Tab</kbd>キーを押すと、これを飛ばして`JButton`にフォーカスが移動
    - 子パネルが`setFocusCycleRoot(false)`の場合、デフォルトフォーカスの`JCheckBox`から<kbd>Tab</kbd>キーを押すと、`JTextArea`にフォーカスが移動

<!-- dummy comment line for breaking list -->

## 参考リンク
- [SortingFocusTraversalPolicy (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/SortingFocusTraversalPolicy.html#setImplicitDownCycleTraversal-boolean-)

<!-- dummy comment line for breaking list -->

## コメント
