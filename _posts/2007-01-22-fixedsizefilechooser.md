---
layout: post
category: swing
folder: FixedSizeFileChooser
title: JFileChooserのリサイズなどを制限
tags: [JFileChooser, JDialog]
author: aterai
pubdate: 2007-01-22T13:27:16+09:00
description: JFileChooserのリサイズや、最小サイズ以下へのサイズ変更を禁止します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTM16q-C_I/AAAAAAAAAZ0/i21vjp9vPjc/s800/FixedSizeFileChooser.png
comments: true
---
## 概要
`JFileChooser`のリサイズや、最小サイズ以下へのサイズ変更を禁止します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTM16q-C_I/AAAAAAAAAZ0/i21vjp9vPjc/s800/FixedSizeFileChooser.png %}

## サンプルコード
<pre class="prettyprint"><code>JFileChooser fileChooser = new JFileChooser() {
  @Override protected JDialog createDialog(Component parent) throws HeadlessException {
    JDialog dialog = super.createDialog(parent);
    dialog.setResizable(false);
    // dialog.setMinimumSize(new Dimension(640, 480)); // JDK 6
    // dialog.addComponentListener(new MinimumSizeAdapter());
    return dialog;
  }
};
</code></pre>

## 解説
上記のサンプルでは、`JFileChooser#createDialog()`メソッドをオーバーライドしてマウスでのリサイズ制限と、最小サイズの設定をテストできます。

`Windows`環境でも、`JDK 6`以上でオーバーライドした`createDialog`メソッド内で`JDialog#setMinimumSize(Dimension)`を使用すれば、最小サイズの設定が可能です。

## 参考リンク
- [Swing - JFileChooser setMinimunSize not working?](https://community.oracle.com/thread/1374445)
- [JFrameの最小サイズ](https://ateraimemo.com/Swing/MinimumFrame.html)

<!-- dummy comment line for breaking list -->

## コメント
