---
layout: post
category: swing
folder: CentredBackgroundBorder
title: JTextAreaの背景に画像を表示
tags: [JTextArea, BufferedImage, Border, JViewport]
author: aterai
pubdate: 2006-03-06T19:15:08+09:00
description: JTextAreaなどのコンポーネントの背景に、Borderを使って中心揃えした画像を表示します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTIyAIY_mI/AAAAAAAAATU/GovGMBqjzRo/s800/CentredBackgroundBorder.png
comments: true
---
## 概要
`JTextArea`などのコンポーネントの背景に、`Border`を使って中心揃えした画像を表示します。[Swing - How can I use TextArea with Background Picture ?](https://community.oracle.com/thread/1395763)のコードを引用しています。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTIyAIY_mI/AAAAAAAAATU/GovGMBqjzRo/s800/CentredBackgroundBorder.png %}

## サンプルコード
<pre class="prettyprint"><code>class CentredBackgroundBorder implements Border {
  private final Insets insets = new Insets(0, 0, 0, 0);
  private final BufferedImage image;
  public CentredBackgroundBorder(BufferedImage image) {
    this.image = image;
  }
  @Override public void paintBorder(
      Component c, Graphics g, int x, int y, int width, int height) {
    int cx = x + (width - image.getWidth()) / 2;
    int cy = y + (height - image.getHeight()) / 2;
    Graphics2D g2 = (Graphics2D) g.create();
    g2.drawRenderedImage(image, AffineTransform.getTranslateInstance(cx, cy));
    g2.dispose();
  }
  @Override public Insets getBorderInsets(Component c) {
    return insets;
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
    
    <pre class="prettyprint"><code>textarea.setOpaque(false);
    textarea.setBackground(new Color(0x0, true)));
</code></pre>

<!-- dummy comment line for breaking list -->
- - - -
`Border`を使って背景に画像を表示する方法は、`JDesktopPane`(参考: [JInternalFrameを半透明にする](https://ateraimemo.com/Swing/TransparentFrame.html))や、その他の`JComponent`でも使用できます。

## 参考リンク
- [Swing - How can I use TextArea with Background Picture ?](https://community.oracle.com/thread/1395763)
- [JInternalFrameを半透明にする](https://ateraimemo.com/Swing/TransparentFrame.html)
- [デジタル出力工房　絵写楽](http://www.bekkoame.ne.jp/~bootan/free2.html)

<!-- dummy comment line for breaking list -->

## コメント
- `centre`は英式の`center`のこと？らしいです。 -- *aterai* 2006-03-23 (木) 00:00:58

<!-- dummy comment line for breaking list -->
