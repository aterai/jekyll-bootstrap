---
layout: post
title: JTextAreaの背景に画像を表示
category: swing
folder: CentredBackgroundBorder
tags: [JTextArea, BufferedImage, Border, JViewport]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-03-06

## 概要
`JTextArea`の背景に画像を表示しています。[Swing - How can I use TextArea with Background Picture ?](https://forums.oracle.com/thread/1395763)のコードを引用しています。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTIyAIY_mI/AAAAAAAAATU/GovGMBqjzRo/s800/CentredBackgroundBorder.png %}

## サンプルコード
<pre class="prettyprint"><code>class CentredBackgroundBorder implements Border {
  private final BufferedImage image;
  public CentredBackgroundBorder(BufferedImage image) {
    this.image = image;
  }
  @Override public void paintBorder(Component c, Graphics g,
      int x, int y, int width, int height) {
    x += (width-image.getWidth())/2;
    y += (height-image.getHeight())/2;
    ((Graphics2D)g).drawRenderedImage(
        image, AffineTransform.getTranslateInstance(x,y));
  }
  @Override public Insets getBorderInsets(Component c) {
    return new Insets(0,0,0,0);
  }
  @Override public boolean isBorderOpaque() {
    return true;
  }
}
</code></pre>

## 解説
上記のサンプルでは、以下のようにして`JTextArea`の背景に画像を表示しています。

- 画像を中央に表示するようにした`Border`を作成し、これを`Viewport`の`Border`として設定
- `Viewport`に追加した`JTextArea`の背景を透明化
    - `textarea.setOpaque(false);`
    - `textarea.setBackground(new Color(0,0,0,0)));`

<!-- dummy comment line for breaking list -->

- - - -
`Border`を使って背景に画像を表示する方法は、`JDesktopPane`(参考:[JInternalFrameを半透明にする](http://terai.xrea.jp/Swing/TransparentFrame.html))や、その他の`JComponent`でも使用することが出来ます。

## 参考リンク
- [Swing - How can I use TextArea with Background Picture ?](https://forums.oracle.com/thread/1395763)
- [JInternalFrameを半透明にする](http://terai.xrea.jp/Swing/TransparentFrame.html)
- [デジタル出力工房　絵写楽](http://www.bekkoame.ne.jp/~bootan/free2.html)

<!-- dummy comment line for breaking list -->

## コメント
- `centre`は英式の`center`のこと？らしいです。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-03-23 (木) 00:00:58

<!-- dummy comment line for breaking list -->

