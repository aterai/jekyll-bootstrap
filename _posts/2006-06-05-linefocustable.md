---
layout: post
title: JTableのフォーカスを一行全体に適用する
category: swing
folder: LineFocusTable
tags: [JTable, Focus, Border]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-06-05

## JTableのフォーカスを一行全体に適用する
`JTable`のフォーカスをセルではなく、一行全体に掛かっているように表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTPOarzqiI/AAAAAAAAAdo/uwFLFlU_EpI/s800/LineFocusTable.png)

### サンプルコード
<pre class="prettyprint"><code>class DotBorder extends EmptyBorder {
  public enum Type { START, END; }
  private static final BasicStroke dashed = new BasicStroke(
    1.0f, BasicStroke.CAP_BUTT, BasicStroke.JOIN_MITER,
    10.0f, (new float[] {1.0f}), 0.0f);
  private static final Color dotColor = new Color(200,150,150);
  public DotBorder(int top, int left, int bottom, int right) {
    super(top, left, bottom, right);
  }
  public EnumSet&lt;Type&gt; type = EnumSet.noneOf(Type.class);
  @Override public boolean isBorderOpaque() {
    return true;
  }
  @Override public void paintBorder(
        Component c, Graphics g, int x, int y, int w, int h) {
    Graphics2D g2 = (Graphics2D)g;
    g2.translate(x,y);
    g2.setPaint(dotColor);
    g2.setStroke(dashed);
    if(type.contains(Type.START)) {
      g2.drawLine(0,0,0,h);
    }
    if(type.contains(Type.END)) {
      g2.drawLine(w-1,0,w-1,h);
    }
    if(c.getBounds().x%2==0) {
      g2.drawLine(0,0,w,0);
      g2.drawLine(0,h-1,w,h-1);
    }else{
      g2.drawLine(1,0,w,0);
      g2.drawLine(1,h-1,w,h-1);
    }
    g2.translate(-x,-y);
  }
}
</code></pre>

### 解説
通常の`JTable`では、`JTable#setRowSelectionAllowed(true)`とすることで選択状態は一行毎になりますが、フォーカスはセル毎のままです。上記のサンプルでは、レンダラーでフォーカスの有るセルを`JTable#getSelectionModel()#getLeadSelectionIndex()`で取得し、独自ラベルを使って最初と最後のセルの垂直の点線、途中のセルの水平点線を描画しています。このため、フォーカスが一行全体に掛かっているように見せることができます。

カラム幅を変更するなどの操作を行っても、セル上下の水平点線のつなぎ目でドットが重ならないようにするため、偶数奇数ドット目のどちらで始まっているかで開始位置をずらしています。

### 参考リンク
- [JTableの次行にTabキーでフォーカスを移動](http://terai.xrea.jp/Swing/SelectNextRow.html)

<!-- dummy comment line for breaking list -->

### コメント
