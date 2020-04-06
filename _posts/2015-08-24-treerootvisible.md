---
layout: post
category: swing
folder: TreeRootVisible
title: JTreeのルートノードを非表示に設定する
tags: [JTree]
author: aterai
pubdate: 2015-08-24T02:45:44+09:00
description: JTreeに表示しているTreeModelのルートノードを表示するかどうかを切り替えます。
image: https://lh3.googleusercontent.com/-XEFtRsrOd3Q/VdoESnrikqI/AAAAAAAAN_0/wxHSA5WkDVg/s800-Ic42/TreeRootVisible.png
comments: true
---
## 概要
`JTree`に表示している`TreeModel`のルートノードを表示するかどうかを切り替えます。

{% download https://lh3.googleusercontent.com/-XEFtRsrOd3Q/VdoESnrikqI/AAAAAAAAN_0/wxHSA5WkDVg/s800-Ic42/TreeRootVisible.png %}

## サンプルコード
<pre class="prettyprint"><code>tree.setRootVisible(false);
</code></pre>

## 解説
上記のサンプルでは、`JTree#setRootVisible(boolean)`メソッドを使用して、`TreeModel`のルートノードが表示されるかどうかを切り替えています。

- `JTree`のデフォルトではルートノードは可視状態(`JTree#isRootVisible() == true`)に設定されている

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTree#setRootVisible(boolean) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTree.html#setRootVisible-boolean-)

<!-- dummy comment line for breaking list -->

## コメント
