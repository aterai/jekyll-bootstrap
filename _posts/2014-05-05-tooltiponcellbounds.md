---
layout: post
category: swing
folder: ToolTipOnCellBounds
title: JListのセル上にToolTipを表示する
tags: [JList, JToolTip, ListCellRenderer]
author: aterai
pubdate: 2014-05-05T01:10:29+09:00
description: JListのセル内に文字列が収まらない場合のみ、その上にToolTipを重ねて表示します。
image: https://lh3.googleusercontent.com/-KLOWyeZG-zU/U2Zif591XkI/AAAAAAAACE0/JDZZwAWkY50/s800/ToolTipOnCellBounds.png
comments: true
---
## 概要
`JList`のセル内に文字列が収まらない場合のみ、その上に`ToolTip`を重ねて表示します。

{% download https://lh3.googleusercontent.com/-KLOWyeZG-zU/U2Zif591XkI/AAAAAAAACE0/JDZZwAWkY50/s800/ToolTipOnCellBounds.png %}

## サンプルコード
<pre class="prettyprint"><code>class TooltipList&lt;E&gt; extends JList&lt;E&gt; {
  public TooltipList(ListModel&lt;E&gt; m) {
    super(m);
  }
  @Override public Point getToolTipLocation(MouseEvent event) {
    Point pt = null;
    if (event != null) {
      Point p = event.getPoint();
      ListCellRenderer&lt;? super E&gt; r = getCellRenderer();
      int i = locationToIndex(p);
      Rectangle cb = getCellBounds(i, i);
      if (i != -1 &amp;&amp; r != null &amp;&amp; cb != null &amp;&amp; cb.contains(p.x, p.y)) {
        ListSelectionModel lsm = getSelectionModel();
        Component rc = r.getListCellRendererComponent(
            this, getModel().getElementAt(i), i, lsm.isSelectedIndex(i),
            hasFocus() &amp;&amp; lsm.getLeadSelectionIndex() == i);
        if (rc instanceof JComponent &amp;&amp; ((JComponent) rc).getToolTipText() != null) {
          pt = cb.getLocation();
        }
      }
    }
    return pt;
  }
}
</code></pre>

## 解説
- 左: `CellBounds`
    - `JList#getToolTipLocation()`をオーバーライドして、表示する`JToolTip`の原点を`JList#getCellBounds(int, int)`で取得したセル領域の左上に変更
- 中: `ListCellRenderer`
    - `JList#getToolTipLocation()`をオーバーライドして、表示する`JToolTip`の原点を`JList#getCellBounds(int, int)`で取得したセル領域の左上に変更
    - `JList#createToolTip()`をオーバーライドして、セルの描画に使用するセルレンダラー自体を`JToolTip`に追加
        - このため、対象セルが選択状態なら、`JToolTip`の背景色もそのセル選択色と同じになる
- 右: `Default`
    - `JToolTip`の表示位置は、デフォルトのマウスカーソルの右下

<!-- dummy comment line for breaking list -->

- - - -
セル内に文字列が収まっているかどうかは、以下のようなセルレンダラーを使用して判定しています。

<pre class="prettyprint"><code>class TooltipListCellRenderer extends DefaultListCellRenderer {
  @Override public Component getListCellRendererComponent(
        JList list, Object value, int index, boolean isSelected, boolean hasFocus) {
    JLabel l = (JLabel) super.getListCellRendererComponent(
        list, value, index, isSelected, hasFocus);
    Insets i = l.getInsets();
    Container c = SwingUtilities.getAncestorOfClass(JViewport.class, list);
    Rectangle rect = c.getBounds();
    rect.width -= i.left + i.right;
    FontMetrics fm = l.getFontMetrics(l.getFont());
    String str = Objects.toString(value, "");
    l.setToolTipText(fm.stringWidth(str) &gt; rect.width ? str : null);
    return l;
  }
}
</code></pre>

## 参考リンク
- [JToolTipの表示位置](http://ateraimemo.com/Swing/ToolTipLocation.html)

<!-- dummy comment line for breaking list -->

## コメント
