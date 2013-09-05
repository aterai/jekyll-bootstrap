---
layout: post
title: JTextAreaに行ハイライトカーソルを表示
category: swing
folder: LineHighlighter
tags: [JTextArea, Caret, JViewport]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-07-24

## JTextAreaに行ハイライトカーソルを表示
`JTextArea`のカーソルがある行をハイライト表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.ggpht.com/_9Z4BYR88imo/TQTPQ5j7_JI/AAAAAAAAAds/kbet-1O8x-A/s800/LineHighlighter.png)

### サンプルコード
<pre class="prettyprint"><code>class HighlightCursorTextArea extends JTextArea {
  private static final Color linecolor = new Color(250,250,220);
  private final DefaultCaret caret;
  public HighlightCursorTextArea() {
    super();
    setOpaque(false);
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
    Graphics2D g2 = (Graphics2D)g;
    Insets i = getInsets();
    int h = caret.height;
    int y = caret.y;
    g2.setPaint(linecolor);
    g2.fillRect(i.left, y, getSize().width-i.left-i.right, h);
    super.paintComponent(g);
  }
}
</code></pre>

### 解説
ほぼ、[JTextAreaに行カーソルを表示](http://terai.xrea.jp/Swing/LineCursor.html)とやっていることは同じです。

違うのは、以下の点になります。

- `Viewport`の色を`scroll.getViewport().setBackground(Color.WHITE)`にする
- `JTextAreaをsetOpaque(false)`と透明にする
- `JTextAreaのpaintComponent(Graphics g)`をオーバーライドするとき、カーソルのある行を塗りつぶしてから`super.paintComponent(g)`する

<!-- dummy comment line for breaking list -->

- - - -
[Swing - Stretching background colour across whole JTextPane for one line of text](https://forums.oracle.com/thread/1364121) の Darryl.Burke さんのコード(以下に部分コピー)のように、`BasicTextPaneUI#paintBackground`をオーバーライドする方法(こちらの方がシンプルで美しいかも)もあります。

<pre class="prettyprint"><code>//JTextPane textPane = new JTextPane();
//textPane.setUI(new LineHighlightTextPaneUI(textPane));
class LineHighlightTextPaneUI extends BasicTextPaneUI {
  private final JTextPane tc;
  public LineHighlightTextPaneUI(JTextPane t) {
    tc = t;
    tc.addCaretListener(new CaretListener() {
      @Override public void caretUpdate(CaretEvent e) {
        tc.repaint();
      }
    });
  }
  @Override public void paintBackground(Graphics g) {
    super.paintBackground(g);
    try{
      Rectangle rect = modelToView(tc, tc.getCaretPosition());
      int y = rect.y;
      int h = rect.height;
      g.setColor(Color.YELLOW);
      g.fillRect(0, y, tc.getWidth(), h);
    }catch(BadLocationException ex) {
      ex.printStackTrace();
    }
  }
}
</code></pre>

これらの方法なら、`JTextEditor`や`JTextPane`で行の高さが異なる場合でも、うまくハイライトできるようです。

![screenshot](https://lh6.ggpht.com/_9Z4BYR88imo/TQTPTaywxYI/AAAAAAAAAdw/RIlfRHiC-JY/s800/LineHighlighter1.png)

### 参考リンク
- [JTextAreaに行カーソルを表示](http://terai.xrea.jp/Swing/LineCursor.html)
- [Swing - Stretching background colour across whole JTextPane for one line of text](https://forums.oracle.com/thread/1364121)

<!-- dummy comment line for breaking list -->

### コメント
- 行の折り返しに対応しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-03-17 (月) 16:22:56

<!-- dummy comment line for breaking list -->
