---
layout: post
title: JTableのセル中にJRadioButtonを配置
category: swing
folder: RadioButtonsInTableCell
tags: [JTable, JRadioButton, TableCellRenderer, TableCellEditor, JPanel, ActionListener]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-12-21

## JTableのセル中にJRadioButtonを配置
`JTable`のセル中に複数の`JRadioButton`を配置します。[JTableExamples2](http://www.crionics.com/products/opensource/faq/swing_ex/JTableExamples2.html)を元に修正を行っています。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTRX5e43uI/AAAAAAAAAhE/QX6qn9jFOB8/s800/RadioButtonsInTableCell.png)

### サンプルコード
<pre class="prettyprint"><code>class RadioButtonsPanel extends JPanel {
  private static final String OSNAME = System.getProperty("os.name");
  private final String[] answer = { "A", "B", "C" };
  public JRadioButton[] buttons;
  public ButtonGroup bg = new ButtonGroup();
  public RadioButtonsPanel() {
    super();
    setLayout(new BoxLayout(this, BoxLayout.X_AXIS));
    initButtons();
  }
  protected void initButtons() {
    bg = new ButtonGroup();
    buttons = new JRadioButton[answer.length];
    for(int i=0;i&lt;buttons.length;i++) {
      buttons[i] = new JRadioButton(answer[i]);
      buttons[i].setActionCommand(answer[i]);
      buttons[i].setFocusable(false);
      buttons[i].setRolloverEnabled(false);
      add(buttons[i]);
      bg.add(buttons[i]);
    }
  }
  protected void updateSelectedButton(Object v) {
    if("Windows 7".equals(OSNAME)) { //Windows aero?
      removeAll();
      initButtons();
    }
    if("A".equals(v)) {
      buttons[0].setSelected(true);
    }else if("B".equals(v)) {
      buttons[1].setSelected(true);
    }else{
      buttons[2].setSelected(true);
    }
  }
}
</code></pre>
<pre class="prettyprint"><code>class RadioButtonsRenderer extends RadioButtonsPanel implements TableCellRenderer {
  public RadioButtonsRenderer() {
    super();
    setName("Table.cellRenderer");
  }
  @Override public Component getTableCellRendererComponent(JTable table,
        Object value, boolean isSelected, boolean hasFocus, int row, int column) {
    updateSelectedButton(value);
    return this;
  }
}
</code></pre>
<pre class="prettyprint"><code>class RadioButtonsEditor extends RadioButtonsPanel implements TableCellEditor {
  public RadioButtonsEditor() {
    super();
    ActionListener al = new ActionListener() {
      @Override public void actionPerformed(ActionEvent e) {
        fireEditingStopped();
      }
    };
    for(AbstractButton b: buttons) b.addActionListener(al);
  }
  @Override public Component getTableCellEditorComponent(JTable table,
        Object value, boolean isSelected, int row, int column) {
    updateSelectedButton(value);
    return this;
  }
  @Override public Object getCellEditorValue() {
    return bg.getSelection().getActionCommand();
  }

  //Copid from AbstractCellEditor
  //protected EventListenerList listenerList = new EventListenerList();
  transient protected ChangeEvent changeEvent = null;
//......
</code></pre>

### 解説
上記のサンプルでは、`JRadioButton`を`3`つ配置した`JPanel`を、`CellRenderer`、`CellEditor`用に`2`つ用意しています。`CellEditor`内の各`JRadioButton`には、クリックされたら編集を終了して更新をコミットするための`ActionListener`を追加しています。


### 参考リンク
- [JTableExamples2](http://www.crionics.com/products/opensource/faq/swing_ex/JTableExamples2.html)
- [Table Button Column ≪ Java Tips Weblog](http://tips4java.wordpress.com/2009/07/12/table-button-column/)
- [JTableのセルに複数のJButtonを配置する](http://terai.xrea.jp/Swing/MultipleButtonsInTableCell.html)
- [JTableのCellにJCheckBoxを複数配置する](http://terai.xrea.jp/Swing/CheckBoxesInTableCell.html)
- [JTableのセルにJRadioButton](http://terai.xrea.jp/Swing/RadioButtonCellEditor.html)

<!-- dummy comment line for breaking list -->

### コメント