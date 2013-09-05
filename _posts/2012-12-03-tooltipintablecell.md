---
layout: post
title: JTableのセルに複数配置したコンポーネントのJToolTip
category: swing
folder: TooltipInTableCell
tags: [JTable, JToolTip, ImageIcon]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-12-03

## JTableのセルに複数配置したコンポーネントのJToolTip
`JTable`のセル中に複数個配置したコンポーネントにそれぞれ`JToolTip`が表示されるように設定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/-OhwzDU_Mys4/ULuQJmYCRiI/AAAAAAAABYQ/Y3Q5mVlliHs/s800/TooltipInTableCell.png)

### サンプルコード
<pre class="prettyprint"><code>JTable table = new JTable(model) {
  @Override public String getToolTipText(MouseEvent e) {
    Point pt = e.getPoint();
    int vrow = rowAtPoint(pt);
    int vcol = columnAtPoint(pt);
    int mcol = convertColumnIndexToModel(vcol);
    if(mcol==1) {
      TableCellRenderer tcr = getCellRenderer(vrow, vcol);
      Component c = prepareRenderer(tcr, vrow, vcol);
      if(c instanceof JPanel) {
        Rectangle r = getCellRect(vrow, vcol, true);
        c.setBounds(r);
        c.doLayout();
        pt.translate(-r.x, -r.y);
        Component l = SwingUtilities.getDeepestComponentAt(c, pt.x, pt.y);
        if(l!=null &amp;&amp; l instanceof JLabel) {
          ImageIcon icon = (ImageIcon)((JLabel)l).getIcon();
          return icon.getDescription();
        }
      }
    }
    return super.getToolTipText(e);
  }
};
</code></pre>

### 解説
上記のサンプルでは、`JTable#getToolTipText(MouseEvent)`をオーバーライドして、`JTable`のセルに複数配置したコンポーネントの情報を`ToolTipText`として返すように設定しています。

- `JTable#getCellRect(...)`で、カーソル下のセル描画に使用されるコンポーネントを取得
- 取得したコンポーネントの位置、サイズ、レイアウトを更新
    - 参考: [java - Tool tip in JPanel in JTable not working - Stack Overflow](http://stackoverflow.com/questions/10854831/tool-tip-in-jpanel-in-jtable-not-working)
- 更新したコンポーネント内から、`SwingUtilities.getDeepestComponentAt()`で、カーソル下のアイコン(`JLabel`)を取得
- `ImageIcon#getDescription()`で取得した文字列を`ToolTipText`として返す

<!-- dummy comment line for breaking list -->

### 参考リンク
- [java - Tool tip in JPanel in JTable not working - Stack Overflow](http://stackoverflow.com/questions/10854831/tool-tip-in-jpanel-in-jtable-not-working)
- [JTableのTooltipsを行ごとに変更](http://terai.xrea.jp/Swing/RowTooltips.html)

<!-- dummy comment line for breaking list -->

### コメント