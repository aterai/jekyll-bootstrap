---
layout: post
title: JTextAreaに行カーソルを表示
category: swing
folder: LineCursor
tags: [JTextArea, Caret, Highlighter]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-01-30

## JTextAreaに行カーソルを表示
`JTextArea`のカーソルがある行全体にアンダーラインを引きます。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTPL3eZj2I/AAAAAAAAAdk/KJTR3_NeAZE/s800/LineCursor.png)

### サンプルコード
<pre class="prettyprint"><code>class LineCursorTextArea extends JTextArea {
  private static final Color cfc = Color.BLUE;
  private final DefaultCaret caret;
  public LineCursorTextArea() {
    super();
    caret = new DefaultCaret() {
      @Override protected synchronized void damage(Rectangle r) {
        if(r!=null) {
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
    Graphics2D g2 = (Graphics2D)g;
    Insets i = getInsets();
    //int y = g2.getFontMetrics().getHeight()*getLineAtCaret(this)+i.top;
    int y = caret.y+caret.height-1;
    g2.setPaint(cfc);
    g2.drawLine(i.left, y, getSize().width-i.left-i.right, y);
  }
//   public static int getLineAtCaret(JTextComponent component) {
//     int caretPosition = component.getCaretPosition();
//     Element root = component.getDocument().getDefaultRootElement();
//     return root.getElementIndex(caretPosition)+1;
//   }
}
</code></pre>

### 解説
`JTextArea#paintComponent`メソッドをオーバーライドして、カーソルがある行にアンダーラインを引いています。

キャレットの移動に対応するため、`DefaultCaret#damage`メソッドを変更して、描画に使われる領域を描画し直しています。

[Highlighting Current Line](http://www.jroller.com/page/santhosh/20050601?catname=%2FSwing)のように、`Highlighter`を使っても同様のことができるようです。

### 参考リンク
- [Swing - Line Number in JTextPane](https://forums.oracle.com/thread/1393939)
- [Swing - Line highlighting problem in presence of text highlighting!](https://forums.oracle.com/thread/1377129)
- [Highlighting Current Line](http://www.jroller.com/page/santhosh/20050601?catname=%2FSwing)
- [JTextAreaに行ハイライトカーソルを表示](http://terai.xrea.jp/Swing/LineHighlighter.html)

<!-- dummy comment line for breaking list -->

### コメント
- `Caret`の高さを使用するように変更しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-03-17 (月) 16:54:50

<!-- dummy comment line for breaking list -->

