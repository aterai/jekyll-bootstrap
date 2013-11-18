---
layout: post
title: JTableHeaderにJCheckBoxを追加してセルの値を切り替える
category: swing
folder: TableHeaderCheckBox
tags: [JTable, JTableHeader, JCheckBox, TableCellRenderer, MouseListener, Icon, JLabel]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-02-16

## JTableHeaderにJCheckBoxを追加してセルの値を切り替える
`JTableHeader`に`JCheckBox`を追加して、同じ列の`JCheckBox`で表示している値をすべて切り替えます。

{% download %}

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTUf8Li6CI/AAAAAAAAAmI/mj7-1IwK86o/s800/TableHeaderCheckBox.png)

### サンプルコード
<pre class="prettyprint"><code>enum Status { SELECTED, DESELECTED, INDETERMINATE }
class HeaderRenderer extends JCheckBox implements TableCellRenderer {
  private final JLabel label = new JLabel("Check All");
  private int targetColumnIndex;
  public HeaderRenderer(JTableHeader header, int index) {
    super((String)null);
    this.targetColumnIndex = index;
    setOpaque(false);
    setFont(header.getFont());
    header.addMouseListener(new MouseAdapter() {
      @Override public void mouseClicked(MouseEvent e) {
        JTableHeader header = (JTableHeader)e.getSource();
        JTable table = header.getTable();
        TableColumnModel columnModel = table.getColumnModel();
        int vci = columnModel.getColumnIndexAtX(e.getX());
        int mci = table.convertColumnIndexToModel(vci);
        if(mci == targetColumnIndex) {
          TableColumn column = columnModel.getColumn(vci);
          Object v = column.getHeaderValue();
          boolean b = Status.DESELECTED.equals(v)?true:false;
          TableModel m = table.getModel();
          for(int i=0; i&lt;m.getRowCount(); i++) m.setValueAt(b, i, mci);
          column.setHeaderValue(b?Status.SELECTED:Status.DESELECTED);
          //header.repaint();
        }
      }
    });
  }
  @Override public Component getTableCellRendererComponent(
      JTable tbl, Object val, boolean isS, boolean hasF, int row, int col) {
    TableCellRenderer r = tbl.getTableHeader().getDefaultRenderer();
    JLabel l = (JLabel)r.getTableCellRendererComponent(tbl,val,isS,hasF,row,col);
    if(targetColumnIndex==tbl.convertColumnIndexToModel(col)) {
      if(val instanceof Status) {
        switch((Status)val) {
          case SELECTED:    setSelected(true);  setEnabled(true);  break;
          case DESELECTED:  setSelected(false); setEnabled(true);  break;
          case INDETERMINATE: setSelected(true);  setEnabled(false); break;
        }
      }else{
        setSelected(true); setEnabled(false);
      }
      label.setIcon(new ComponentIcon(this));
      l.setIcon(new ComponentIcon(label));
      l.setText(null); //XXX: Nimbus???
    }
    return l;
  }
}
class ComponentIcon implements Icon{
  private final JComponent cmp;
  public ComponentIcon(JComponent cmp) {
    this.cmp = cmp;
  }
  @Override public int getIconWidth() {
    return cmp.getPreferredSize().width;
  }
  @Override public int getIconHeight() {
    return cmp.getPreferredSize().height;
  }
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {
    SwingUtilities.paintComponent(
        g, cmp, (Container)c, x, y, getIconWidth(), getIconHeight());
  }
}
</code></pre>

### 解説
上記のサンプルでは、`JCheckBox`のアイコンを作成して、これを`TableCellRenderer`(=`JLabel`)に`setIcon`することで描画しています。このため、ヘッダに追加した`MouseListener`で切り替えを行っています。

- - - -
- `JTable`のセル中にある`JCheckBox`が全てチェックされた場合、ヘッダの`JCheckBox`もチェックされる
- `JTable`のセル中にある`JCheckBox`のチェックが全てクリアされた場合、ヘッダの`JCheckBox`のチェックもクリアされる
- `JTable`のセル中にある`JCheckBox`でチェックの有無が混在している場合、ヘッダの`JCheckBox`は薄くチェックされた状態(`setEnabled(false)`で`setSelected(true)`)になる

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>model.addTableModelListener(new TableModelListener() {
  @Override public void tableChanged(TableModelEvent e) {
    if(e.getType()==TableModelEvent.UPDATE &amp;&amp; e.getColumn()==targetColumnIndex) {
      int vci = table.convertColumnIndexToView(targetColumnIndex);
      TableColumn column = table.getColumnModel().getColumn(vci);
      if(!Status.INDETERMINATE.equals(column.getHeaderValue())) {
        column.setHeaderValue(Status.INDETERMINATE);
      }else{
        boolean selected = true, deselected = true;
        TableModel m = table.getModel();
        for(int i=0; i&lt;m.getRowCount(); i++) {
          Boolean b = (Boolean)m.getValueAt(i, targetColumnIndex);
          selected &amp;= b; deselected &amp;= !b;
          if(selected==deselected) return;
        }
        if(selected) {
          column.setHeaderValue(Status.SELECTED);
        }else if(deselected) {
          column.setHeaderValue(Status.DESELECTED);
        }else{
          return;
        }
      }
      JTableHeader h = table.getTableHeader();
      h.repaint(h.getHeaderRect(vci));
    }
  }
});
</code></pre>

### 参考リンク
- [Check Box in JTable header (Swing / AWT / SWT / JFace forum at JavaRanch)](http://www.coderanch.com/t/343795/Swing-AWT-SWT-JFace/java/Check-Box-JTable-header)
- [JCheckBoxに不定状態のアイコンを追加する](http://terai.xrea.jp/Swing/TriStateCheckBox.html)

<!-- dummy comment line for breaking list -->

### コメント
- `LookAndFeel`を`Nimbus`に変更したとき、`JTableHeader`の高さがおかしい？ -- [aterai](http://terai.xrea.jp/aterai.html) 2011-05-30 (月) 22:13:05
    - レンダラー中で`label.setText(null);`や、`JLabel`を挟んで二重に`ImageIcon`を作成するなどして回避中。 -- [aterai](http://terai.xrea.jp/aterai.html) 2012-03-02 (金) 16:01:51
- [Java Swing Tips: JTableHeader CheckBox](http://java-swing-tips.blogspot.com/2009/02/jtableheader-checkbox.html)で、ヘッダクリックで全選択した後、テーブル中のチェックを外すと、ヘッダのチェックボックスもチェック外した方がよくないか？との指摘を頂いたので、(`Gmail`などのチェックボックス風の)不定状態？を導入しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2011-06-14 (火) 14:44:19

<!-- dummy comment line for breaking list -->

