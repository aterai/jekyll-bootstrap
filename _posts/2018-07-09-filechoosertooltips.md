---
layout: post
category: swing
folder: FileChooserToolTips
title: JFileChooserのファイル一覧にJToolTipを設定する
tags: [JFileChooser, JToolTip, JList, JTable]
author: aterai
pubdate: 2018-07-09T15:06:13+09:00
description: JFileChooserの詳細ファイル一覧でファイル名が省略されている場合にJToolTipでそれを表示します。
image: https://drive.google.com/uc?id=1GzSb_32IGNEjqMVqMCqzG2K8j41cSeKrdQ
comments: true
---
## 概要
`JFileChooser`の詳細ファイル一覧でファイル名が省略されている場合に`JToolTip`でそれを表示します。

{% download https://drive.google.com/uc?id=1GzSb_32IGNEjqMVqMCqzG2K8j41cSeKrdQ %}

## サンプルコード
<pre class="prettyprint"><code>JButton button3 = new JButton("JTable tooltips");
button3.addActionListener(e -&gt; {
  JFileChooser chooser = new JFileChooser();
  Optional.ofNullable(chooser.getActionMap().get("viewTypeDetails"))
    .ifPresent(a -&gt; a.actionPerformed(
      new ActionEvent(e.getSource(), e.getID(), "viewTypeDetails")));
  stream(chooser)
    .filter(JTable.class::isInstance)
    .map(JTable.class::cast)
    .findFirst()
    .ifPresent(MainPanel::setCellRenderer);
  int retvalue = chooser.showOpenDialog(log.getRootPane());
  if (retvalue == JFileChooser.APPROVE_OPTION) {
    log.setText(chooser.getSelectedFile().getAbsolutePath());
  }
});
// ...
private static void setCellRenderer(JTable table) {
  table.setDefaultRenderer(Object.class, new TooltipTableCellRenderer());
}
// ...
class TooltipTableCellRenderer implements TableCellRenderer {
  private final TableCellRenderer renderer = new DefaultTableCellRenderer();
  @Override public Component getTableCellRendererComponent(
      JTable table, Object value, boolean isSelected, boolean hasFocus,
      int row, int column) {
    JLabel l = (JLabel) renderer.getTableCellRendererComponent(
        table, value, isSelected, hasFocus, row, column);
    Insets i = l.getInsets();
    Rectangle rect = table.getCellRect(row, column, false);
    rect.width -= i.left + i.right;
    Optional.ofNullable(l.getIcon())
      .ifPresent(icon -&gt; rect.width -= icon.getIconWidth() + l.getIconTextGap());
    FontMetrics fm = l.getFontMetrics(l.getFont());
    String str = Objects.toString(value, "");
    l.setToolTipText(fm.stringWidth(str) &gt; rect.width ? str : null);
    return l;
  }
}
</code></pre>

## 解説
- `Default`
    - `JFileChooser`のリスト一覧、詳細一覧ともに`JToolTip`は設定されていない
- `JList tooltips`
    - `JFileChooser`のリスト一覧(`JList`)をすべて検索して、`JList#setCellRenderer(...)`で`JToolTip`を表示するための`ListCellRenderer`を設定
        - 参考: [Containerの子Componentを再帰的にすべて取得する](https://ateraimemo.com/Swing/GetComponentsRecursively.html)
- `JTable tooltips`
    - `JFileChooser`の詳細一覧(`JTable`)を検索して最初に見つかった`JTable`に、`JTable#setCellRenderer(...)`で`JToolTip`を表示するための`TableCellRenderer`を設定
        - 参考: [JFileChooserのデフォルトをDetails Viewに設定](https://ateraimemo.com/Swing/DetailsViewFileChooser.html)
    - セルが省略されている場合のみ`JToolTip`を表示
        - 参考: [JTableのセルがクリップされている場合のみJToolTipを表示](https://ateraimemo.com/Swing/ClippedCellTooltips.html)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Containerの子Componentを再帰的にすべて取得する](https://ateraimemo.com/Swing/GetComponentsRecursively.html)
- [JFileChooserのデフォルトをDetails Viewに設定](https://ateraimemo.com/Swing/DetailsViewFileChooser.html)
- [JTableのセルがクリップされている場合のみJToolTipを表示](https://ateraimemo.com/Swing/ClippedCellTooltips.html)

<!-- dummy comment line for breaking list -->

## コメント
