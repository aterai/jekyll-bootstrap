---
layout: post
category: swing
folder: MultipleButtonsInTableCell
title: JTableのセルに複数のJButtonを配置する
tags: [JTable, TableCellEditor, TableCellRenderer, JButton, JPanel, ActionListener]
author: aterai
pubdate: 2009-10-05T12:57:02+09:00
description: JTableのセル内にクリック可能な複数のJButtonを配置します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTQRygoYeI/AAAAAAAAAfU/-Sr9o7PsQkM/s800/MultipleButtonsInTableCell.png
hreflang:
    href: http://java-swing-tips.blogspot.com/2009/10/multiple-jbuttons-in-jtable-cell.html
    lang: en
comments: true
---
## 概要
`JTable`のセル内にクリック可能な複数の`JButton`を配置します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTQRygoYeI/AAAAAAAAAfU/-Sr9o7PsQkM/s800/MultipleButtonsInTableCell.png %}

## サンプルコード
<pre class="prettyprint"><code>class ButtonsPanel extends JPanel {
  public final List&lt;JButton&gt; buttons =
    Arrays.asList(new JButton("view"), new JButton("edit"));
  public ButtonsPanel() {
    super();
    setOpaque(true);
    for (JButton b: buttons) {
      b.setFocusable(false);
      b.setRolloverEnabled(false);
      add(b);
    }
  }
}
</code></pre>
<pre class="prettyprint"><code>class ButtonsRenderer extends ButtonsPanel
                      implements TableCellRenderer {
  public ButtonsRenderer() {
    super();
    setName("Table.cellRenderer");
  }
  @Override public Component getTableCellRendererComponent(JTable table,
        Object value, boolean isSelected, boolean hasFocus, int row, int column) {
    setBackground(isSelected?table.getSelectionBackground():table.getBackground());
    return this;
  }
}
</code></pre>
<pre class="prettyprint"><code>class ButtonsEditor extends ButtonsPanel
                    implements TableCellEditor {
  public ButtonsEditor(final JTable table) {
    super();
    //----&gt;
    //DEBUG: view button click -&gt; control key down + edit button(same cell) press
    //       -&gt; remain selection color
    MouseListener ml = new MouseAdapter() {
      @Override public void mousePressed(MouseEvent e) {
        ButtonModel m = ((JButton) e.getSource()).getModel();
        if (m.isPressed() &amp;&amp; table.isRowSelected(table.getEditingRow())
                          &amp;&amp; e.isControlDown()) {
          setBackground(table.getBackground());
        }
      }
    };
    buttons.get(0).addMouseListener(ml);
    buttons.get(1).addMouseListener(ml);
    //&lt;----

    buttons.get(0).addActionListener(new ActionListener() {
      @Override public void actionPerformed(ActionEvent e) {
        fireEditingStopped();
        JOptionPane.showMessageDialog(table, "Viewing");
      }
    });

    buttons.get(1).addActionListener(new ActionListener() {
      @Override public void actionPerformed(ActionEvent e) {
        int row = table.convertRowIndexToModel(table.getEditingRow());
        Object o = table.getModel().getValueAt(row, 0);
        fireEditingStopped();
        JOptionPane.showMessageDialog(table, "Editing: " + o);
      }
    });

    addMouseListener(new MouseAdapter() {
      @Override public void mousePressed(MouseEvent e) {
        fireEditingStopped();
      }
    });
  }
  @Override public Component getTableCellEditorComponent(JTable table,
        Object value, boolean isSelected, int row, int column) {
    this.setBackground(table.getSelectionBackground());
    return this;
  }
  @Override public Object getCellEditorValue() {
    return "";
  }
  //Copied from AbstractCellEditor
  //protected EventListenerList listenerList = new EventListenerList();
  transient protected ChangeEvent changeEvent = null;
  @Override public boolean isCellEditable(java.util.EventObject e) {
    return true;
  }
//......
</code></pre>

## 解説
上記のサンプルでは、`CellRenderer`用と`CellEditor`用に、`JButton`を`2`つ配置した`JPanel`をそれぞれ作成しています。`CellRenderer`用の`JButton`は表示のみに使用するため、アクションを設定するのは`CellEditor`用の`JButton`のみです。

- - - -
- `LookAndFeel`などが更新されたら、`JTable#updateUI()`メソッド内で`SwingUtilities#updateRendererOrEditorUI()`メソッドを呼び出すなどして、各セルレンダラーやセルエディタ(これらは`JTable`の子コンポーネントではないので)を更新
    - `AbstractCellEditor`を継承するセルエディタは、`Component`も`DefaultCellEditor`も継承していないので、`LookAndFeel`を変更しても追従しない
    - そのため、`JTable#updateUI()`をオーバーライドして、セルエディタ自体を再作成するなどの対応が必要
- このサンプルでは、`Component`を継承(`TableCellEditor`を実装)するセルエディタを作成し、`AbstractCellEditor`から必要なメソッドをコピーして回避している

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>//SwingUtilities#updateRendererOrEditorUI()
static void updateRendererOrEditorUI(Object rendererOrEditor) {
  if (rendererOrEditor == null) {
    return;
  }
  Component component = null;
  if (rendererOrEditor instanceof Component) {
    component = (Component) rendererOrEditor;
  }
  if (rendererOrEditor instanceof DefaultCellEditor) {
    component = ((DefaultCellEditor) rendererOrEditor).getComponent();
  }
  if (component != null) {
    SwingUtilities.updateComponentTreeUI(component);
  }
}
</code></pre>

- - - -
- `JSpinner`(`2`つの`JButton`と`JTextField`の組み合わせ)を`CellEditor`に使用する
    - [JTableのCellEditorにJPanelを使用して複数コンポーネントを配置](http://ateraimemo.com/Swing/PanelCellEditorRenderer.html)に移動

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableのセルにJButtonを追加して行削除](http://ateraimemo.com/Swing/DeleteButtonInCell.html)
- [JTableのセルにHyperlinkを表示](http://ateraimemo.com/Swing/HyperlinkInTableCell.html)
- [Table Button Column « Java Tips Weblog](http://tips4java.wordpress.com/2009/07/12/table-button-column/)
- [JTableのセル中にJRadioButtonを配置](http://ateraimemo.com/Swing/RadioButtonsInTableCell.html)
- [JTableのCellにJCheckBoxを複数配置する](http://ateraimemo.com/Swing/CheckBoxesInTableCell.html)

<!-- dummy comment line for breaking list -->

## コメント
- 第`0`列目が編集状態でボタンをクリックした場合、パネルが`2`度表示されるバグを修正。 -- *aterai* 2009-10-06 (火) 11:56:21
- [Table Button Column « Java Tips Weblog](http://tips4java.wordpress.com/2009/07/12/table-button-column/)を参考にして、`JTable#editCellAt`ではなく、逆に`TableCellEditor#stopCellEditing()`を使用してクリック直後に編集終了するように変更。 -- *aterai* 2009-11-03 (火) 04:36:55
- <kbd>Ctrl</kbd>キーを押しながら、`edit`ボタンをクリックすると異なる行(`table.getSelectedRow()`)の内容が表示されるバグを修正。 -- *aterai* 2011-03-10 (木) 02:35:35
- すごいと思いました！ -- *いわく* 2013-05-24 (金) 11:57:26
    - こんばんは。たしかに`JTable`の`TableCellRenderer`、`TableCellEditor`の仕組みは、すごい良くできているといつも感心してしまいます :) -- *aterai* 2013-05-24 (金) 23:59:16

<!-- dummy comment line for breaking list -->
