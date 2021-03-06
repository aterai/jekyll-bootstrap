---
layout: post
category: swing
folder: ExplorerLikeTable
title: JTableのセルをエクスプローラ風に表示する
tags: [JTable, TableCellRenderer, JLabel, Focus]
author: aterai
pubdate: 2006-07-17T08:23:31+09:00
description: セルの中にアイコンと文字列を配置し、エクスプローラ風に見えるよう、文字列だけにフォーカスをかけます。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTMWzLLVKI/AAAAAAAAAZA/k3vF14Jt-V0/s800/ExplorerLikeTable.png
comments: true
---
## 概要
セルの中にアイコンと文字列を配置し、エクスプローラ風に見えるよう、文字列だけにフォーカスをかけます。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTMWzLLVKI/AAAAAAAAAZA/k3vF14Jt-V0/s800/ExplorerLikeTable.png %}

## サンプルコード
<pre class="prettyprint"><code>class TestRenderer extends Box implements TableCellRenderer {
  private final Border emptyBorder = BorderFactory.createEmptyBorder(1, 1, 1, 1);
  private final ImageIcon nicon;
  private final ImageIcon sicon;
  private final JLabel textLabel;
  private final JLabel iconLabel;
  public TestRenderer(JTable table) {
    super(BoxLayout.X_AXIS);
    textLabel = new JLabel("dummy");
    textLabel.setOpaque(true);
    textLabel.setBorder(emptyBorder);
    nicon = new ImageIcon(getClass().getResource("wi0063-16.png"));
    FilteredImageSource fis = new FilteredImageSource(
      nicon.getImage().getSource(), new SelectedImageFilter());
    sicon = new ImageIcon(createImage(fis));
    iconLabel = new JLabel(nicon);
    iconLabel.setBorder(BorderFactory.createEmptyBorder());
    table.setRowHeight(Math.max(textLabel.getPreferredSize().height,
                  iconLabel.getPreferredSize().height));
    add(iconLabel);
    add(textLabel);
    add(Box.createHorizontalGlue());
  }
  @Override public Component getTableCellRendererComponent(JTable table,
      Object value, boolean isSelected, boolean hasFocus, int row, int column) {
    textLabel.setText(Objects.toString(value, ""));
    FontMetrics fm = table.getFontMetrics(table.getFont());
    int swidth = fm.stringWidth(textLabel.getText()) + textLabel.getInsets().left
                              + textLabel.getInsets().right;
    int cwidth = table.getColumnModel().getColumn(column).getWidth()
                   -iconLabel.getPreferredSize().width;
    textLabel.setPreferredSize(new Dimension(swidth &gt; cwidth ? cwidth : swidth, 0));
    if (isSelected) {
      textLabel.setForeground(table.getSelectionForeground());
      textLabel.setBackground(table.getSelectionBackground());
    } else {
      textLabel.setForeground(table.getForeground());
      textLabel.setBackground(table.getBackground());
    }
    if (hasFocus) {
      textLabel.setBorder(UIManager.getBorder("Table.focusCellHighlightBorder"));
    } else {
      textLabel.setBorder(emptyBorder);
    }
    textLabel.setFont(table.getFont());
    iconLabel.setIcon(isSelected?sicon:nicon);
    return this;
  }
  private static class SelectedImageFilter extends RGBImageFilter {
    public SelectedImageFilter() {
      canFilterIndexColorModel = false;
    }
    @Override public int filterRGB(int x, int y, int argb) {
      //Color color = new Color(argb, true);
      //float[] array = new float[4];
      //color.getComponents(array);
      //return new Color(array[0] * .5f, array[1] * .5f, array[2], array[3]).getRGB();
      int r = (argb &gt;&gt; 16) &amp; 0xFF;
      int g = (argb &gt;&gt;  8) &amp; 0xFF;
      return (argb &amp; 0xFF_00_00_FF) | ((r &gt;&gt; 1) &lt;&lt; 16) | ((g &gt;&gt; 1) &lt;&lt; 8);
    }
  }
}
</code></pre>

## 解説
`Windows Explorer`(ファイルシステム・エクスプローラ)の詳細表示風にするため、以下のような設定をしています。

- セル間の罫線を非表示(`JTable#setShowHorizontalLines`, `JTable#setShowVerticalLines`)
- ひとつのセルの中でアイコンと文字列を表示するセルレンダラーを作成
- フォーカスが`JTable`に無い場合、選択されたセルの背景色をパネルの背景色に変更

<!-- dummy comment line for breaking list -->

このレンダラーでは、アイコンと文字列を別々の`JLabel`で作成して並べることで、`JList#putClientProperty("List.isFileList", Boolean.TRUE)`した場合のように、フォーカスはセルではなく文字列だけに点線で掛かるようになっています。

選択時にはセル全体の背景色を変更するのではなく、文字列を表示している`JLabel`の背景色を変更し、その`PreferredSize`を文字列の長さまで縮小して右側に余白を作成しています。

- `Windows Explorer`との相違点
    - アイコンと文字列以外の場所(セル内)をクリックしても、選択できてしまう
        - `WindowsLookAndFeel`での`JFileChooser`は、`JTable.putClientProperty("Table.isFileList", Boolean.TRUE)`を使用？
        - [JTableで文字列をクリックした場合だけセルを選択状態にする](https://ateraimemo.com/Swing/TableFileList.html)
    - マウスドラッグによる範囲指定で選択できない
        - [JTableで文字列をクリックした場合だけセルを選択状態にする](https://ateraimemo.com/Swing/TableFileList.html)
        - [JListのアイテムを範囲指定で選択](https://ateraimemo.com/Swing/RubberBanding.html)
    - ~~ソートすると選択状態がクリアされてしまう~~
        - `TableRowSorter`では標準で選択状態を維持するようになった
        - [TableSorterでソートしても選択状態を維持](https://ateraimemo.com/Swing/SelectionKeeper.html)
    - ~~<kbd>Tab</kbd>キー、矢印キーによる選択状態の移動がおかしい~~
    - 編集不可

<!-- dummy comment line for breaking list -->

## 参考リンク
- [XP Style Icons - Download](https://xp-style-icons.en.softonic.com/)
- [JTableで文字列をクリックした場合だけセルを選択状態にする](https://ateraimemo.com/Swing/TableFileList.html)

<!-- dummy comment line for breaking list -->

## コメント
