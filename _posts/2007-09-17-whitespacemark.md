---
layout: post
title: JTextPaneで全角スペースやタブを可視化
category: swing
folder: WhitespaceMark
tags: [JTextPane, LabelView]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-09-17

## JTextPaneで全角スペースやタブを可視化
`JTextPane`に表示した文字列中の全角スペースやタブを可視化します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTWpb1ogMI/AAAAAAAAApk/3IWJ2qvvECo/s800/WhitespaceMark.png)

### サンプルコード
<pre class="prettyprint"><code>class WhitespaceLabelView extends LabelView {
  private static final Color pc = new Color(130, 140, 120);
  private static final BasicStroke dashed = new BasicStroke(1.0f, BasicStroke.CAP_BUTT,
       BasicStroke.JOIN_MITER, 10.0f, new float[] {1.0f}, 0.0f);
  public WhitespaceLabelView(Element elem) {
    super(elem);
  }
  @Override public void paint(Graphics g, Shape a) {
    super.paint(g,a);
    Graphics2D g2 = (Graphics2D)g;
    Stroke stroke = g2.getStroke();
    Rectangle alloc = (a instanceof Rectangle) ? (Rectangle)a : a.getBounds();
    FontMetrics fontMetrics = g.getFontMetrics();
    int spaceWidth = fontMetrics.stringWidth("　");
    int sumOfTabs  = 0;
    String text = getText(getStartOffset(),getEndOffset()).toString();
    for(int i=0;i&lt;text.length();i++) {
      String s = text.substring(i,i+1);
      int previousStringWidth = fontMetrics.stringWidth(text.substring(0,i)) + sumOfTabs;
      int sx = alloc.x+previousStringWidth;
      int sy = alloc.y+alloc.height-fontMetrics.getDescent();
      if("　".equals(s)) {
        g2.setStroke(dashed);
        g2.setPaint(pc);
        g2.drawLine(sx+1, sy-1, sx+spaceWidth-2, sy-1);
        g2.drawLine(sx+2,   sy, sx+spaceWidth-2, sy);
      }else if("\t".equals(s)) {
        int tabWidth = (int)getTabExpander().nextTabStop((float)sx, i)-sx;
        g2.setColor(pc);
        g2.drawLine(sx+2, sy-0, sx+2+2, sy-0);
        g2.drawLine(sx+2, sy-1, sx+2+1, sy-1);
        g2.drawLine(sx+2, sy-2, sx+2+0, sy-2);
        g2.setStroke(dashed);
        g2.drawLine(sx+2, sy, sx+tabWidth-2, sy);
        sumOfTabs+=tabWidth;
      }
      g2.setStroke(stroke);
    }
  }
}
</code></pre>

### 解説
上記のサンプルでは、`LabelView`を継承し、`LabelView#paint`メソッドをオーバーライドして全角スペースやタブの場合だけ、それぞれの図形を描画しています。

- 注: タブの図形は、`xyzzy`風だが、ドットの数は面倒なので適当

<!-- dummy comment line for breaking list -->

この`LabelView`を使用する`EditorKit(ViewFactory)`の作成は、[JEditorPaneで改行を表示](http://terai.xrea.jp/Swing/ParagraphMark.html)と同様になっています。

### 参考リンク
- [Swing - JTextPane View Problem](https://forums.oracle.com/thread/1374478)
- [Design Guidelines: Text Components](http://web.archive.org/web/20120216035951/http://java.sun.com/products/jlf/ed1/dg/higo.htm)
- [Swing Chapter 19. (Advanced topics) Inside Text Components. Easy for reading, Click here!](http://www.javafaq.nu/java-book-30.html)
- [JEditorPaneで改行を表示](http://terai.xrea.jp/Swing/ParagraphMark.html)
- [JTextPaneでタブサイズを設定](http://terai.xrea.jp/Swing/TabSize.html)

<!-- dummy comment line for breaking list -->

### コメント
