---
layout: post
title: JFileChooserのリサイズなどを制限
category: swing
folder: FixedSizeFileChooser
tags: [JFileChooser, JDialog]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-01-22

## JFileChooserのリサイズなどを制限
`JFileChooser`のリサイズや、最小サイズ以下へのサイズ変更を禁止します。

{% download %}

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTM16q-C_I/AAAAAAAAAZ0/i21vjp9vPjc/s800/FixedSizeFileChooser.png)

### サンプルコード
<pre class="prettyprint"><code>JFileChooser fileChooser = new JFileChooser() {
  @Override protected JDialog createDialog(Component parent) throws HeadlessException {
    JDialog dialog = super.createDialog(parent);
    dialog.setResizable(false);
    //dialog.setMinimumSize(new Dimension(640,480)); // JDK 6
    //dialog.addComponentListener(new MinimumSizeAdapter());
    return dialog;
  }
};
</code></pre>

### 解説
`JFileChooser`の`createDialog`メソッドをオーバーライドして、リサイズを制限したり、最小サイズを設定したりしています。

`JDK 6`では、`Windows`環境でも、オーバーライドした`createDialog`メソッド内で、`JDialog#setMinimumSize(Dimension)`を使うだけで、最小サイズの設定が出来るようになっています。

### 参考リンク
- [Swing - JFileChooser setMinimunSize not working?](https://forums.oracle.com/thread/1374445)
- [JFrameの最小サイズ](http://terai.xrea.jp/Swing/MinimumFrame.html)

<!-- dummy comment line for breaking list -->

### コメント
