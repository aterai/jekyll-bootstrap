---
layout: post
category: swing
folder: LineCursor
title: JTextAreaに行カーソルを表示
tags: [JTextArea, Caret, Highlighter]
author: aterai
pubdate: 2006-01-30T12:22:18+09:00
description: JTextAreaのカーソルがある行全体にアンダーラインを引きます。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTPL3eZj2I/AAAAAAAAAdk/KJTR3_NeAZE/s800/LineCursor.png
comments: true
---
## 概要
`JTextArea`のカーソルがある行全体にアンダーラインを引きます。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTPL3eZj2I/AAAAAAAAAdk/KJTR3_NeAZE/s800/LineCursor.png %}

## サンプルコード
<pre class="prettyprint"><code>class LineCursorTextArea extends JTextArea {
  private static final Color LINE_COLOR = Color.BLUE;
  private DefaultCaret caret;

  @Override public void updateUI() {
    super.updateUI();
    caret = new DefaultCaret() {
      @Override protected synchronized void damage(Rectangle r) {
        if (r != null) {
          JTextComponent c = getComponent();
          x = 0;
          y = r.y;
          width  = c.getSize().width;
          height = r.height;
          c.repaint();
        }
      }
    };
    caret.setBlinkRate(getCaret().getBlinkRate());
    setCaret(caret);
  }

  @Override protected void paintComponent(Graphics g) {
    super.paintComponent(g);
    Graphics2D g2 = (Graphics2D) g.create();
    Insets i = getInsets();
    int y = caret.y + caret.height - 1;
    g2.setPaint(LINE_COLOR);
    g2.drawLine(i.left, y, getSize().width - i.left - i.right, y);
    g2.dispose();
  }

  // public static int getLineAtCaret(JTextComponent component) {
  //   int caretPosition = component.getCaretPosition();
  //   Element root = component.getDocument().getDefaultRootElement();
  //   return root.getElementIndex(caretPosition) + 1;
  // }
}
</code></pre>

## 解説
`JTextArea#paintComponent`メソッドをオーバーライドして、カーソルがある行にアンダーラインを引いています。

- `Caret`の移動に対応するため、`DefaultCaret#damage(Rectangle)`メソッドをオーバーライドして変更された領域を再描画
- [Highlighting Current Line](http://www.jroller.com/page/santhosh/20050601?catname=%2FSwing)のように`Highlighter`を使用する方法もある

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Swing - Line Number in JTextPane](https://community.oracle.com/thread/1393939)
- [Swing - Line highlighting problem in presence of text highlighting!](https://community.oracle.com/thread/1377129)
- [Highlighting Current Line](http://www.jroller.com/page/santhosh/20050601?catname=%2FSwing)
- [JTextAreaに行ハイライトカーソルを表示](https://ateraimemo.com/Swing/LineHighlighter.html)

<!-- dummy comment line for breaking list -->

## コメント
- `Caret`の高さを使用するように変更しました。 -- *aterai* 2008-03-17 (月) 16:54:50

<!-- dummy comment line for breaking list -->
