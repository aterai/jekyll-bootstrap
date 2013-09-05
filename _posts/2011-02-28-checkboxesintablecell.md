---
layout: post
title: JTableのCellにJCheckBoxを複数配置する
category: swing
folder: CheckBoxesInTableCell
tags: [JTable, JCheckBox, TableCellRenderer, TableCellEditor, JPanel, InputMap, ActionMap]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-02-28

## JTableのCellにJCheckBoxを複数配置する
`JTable`のセル中に`JCheckBox`を複数個配置します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TWs6JY73P8I/AAAAAAAAA2M/wwrwT7R5K4k/s800/CheckBoxesInTableCell.png)

### サンプルコード
<pre class="prettyprint"><code>class CheckBoxesPanel extends JPanel {
  protected final String[] title = {"r", "w", "x"};
  public JCheckBox[] buttons;
  public CheckBoxesPanel() {
    super();
    setOpaque(false);
    setBackground(new Color(0,0,0,0));
    setLayout(new BoxLayout(this, BoxLayout.X_AXIS));
    initButtons();
  }
  protected void initButtons() {
    buttons = new JCheckBox[title.length];
    for(int i=0; i&lt;buttons.length; i++) {
      JCheckBox b = new JCheckBox(title[i]);
      b.setOpaque(false);
      b.setFocusable(false);
      b.setRolloverEnabled(false);
      b.setBackground(new Color(0,0,0,0));
      buttons[i] = b;
      add(b);
      add(Box.createHorizontalStrut(5));
    }
  }
  private static final String OSNAME = System.getProperty("os.name");
  protected void updateButtons(Object v) {
    if("Windows 7".equals(OSNAME)) { //Windows aero?
      removeAll();
      initButtons();
    }
    Integer i = (Integer)(v==null?0:v);
    buttons[0].setSelected((i&amp;(1&lt;&lt;2))!=0);
    buttons[1].setSelected((i&amp;(1&lt;&lt;1))!=0);
    buttons[2].setSelected((i&amp;(1&lt;&lt;0))!=0);
  }
}
</code></pre>

<pre class="prettyprint"><code>class CheckBoxesRenderer extends CheckBoxesPanel
                         implements TableCellRenderer, Serializable {
  public CheckBoxesRenderer() {
    super();
    setName("Table.cellRenderer");
  }
  @Override public Component getTableCellRendererComponent(JTable table,
      Object value, boolean isSelected, boolean hasFocus, int row, int column) {
    updateButtons(value);
    return this;
  }
  public static class UIResource extends CheckBoxesRenderer
                                 implements UIResource{}
}
</code></pre>

<pre class="prettyprint"><code>class CheckBoxesEditor extends CheckBoxesPanel
                       implements TableCellEditor, Serializable {
  public CheckBoxesEditor() {
    ActionListener al = new ActionListener() {
      @Override public void actionPerformed(ActionEvent e) {
        fireEditingStopped();
      }
    };
    ActionMap am = getActionMap();
    for(int i=0; i&lt;buttons.length; i++) {
      final JCheckBox b = buttons[i];
      b.addActionListener(al);
      am.put(title[i], new AbstractAction(title[i]) {
        public void actionPerformed(ActionEvent e) {
          b.setSelected(!b.isSelected());
          fireEditingStopped();
        }
      });
    }
    InputMap im = getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW);
    im.put(KeyStroke.getKeyStroke(KeyEvent.VK_R, 0), title[0]);
    im.put(KeyStroke.getKeyStroke(KeyEvent.VK_W, 0), title[1]);
    im.put(KeyStroke.getKeyStroke(KeyEvent.VK_X, 0), title[2]);
  }
  @Override public Component getTableCellEditorComponent(JTable table,
        Object value, boolean isSelected, int row, int column) {
    updateButtons(value);
    return this;
  }
  @Override public Object getCellEditorValue() {
    int i = 0;
    if(buttons[0].isSelected()) i|=1&lt;&lt;2;
    if(buttons[1].isSelected()) i|=1&lt;&lt;1;
    if(buttons[2].isSelected()) i|=1&lt;&lt;0;
    return i;
  }

  //Copid from AbstractCellEditor
  protected EventListenerList listenerList = new EventListenerList();
  transient protected ChangeEvent changeEvent = null;
  //......
</code></pre>

### 解説
上記のサンプルでは、`JTable`のセル内に`3`つの`JCheckBox`を配置した`JPanel`を作成し、これを`CellRenderer`と`CellEditor`として別々に使用しています。`JCheckBox`をマウスでクリックすると、その`JCheckBox`の選択状態だけが変化します。

- - - -
ヘッダカラムの移動、リサイズ(`JFrame`などのリサイズ)で、チェックした内容が消えてしまわないように、`CellEditor`のチェックボックスがクリックされたら`fireEditingStopped()`メソッドを呼び出して編集を終了し更新を確定するようにしています。

~~`JTable`自体に以下の様な`MouseListener`を追加してチェックボックスがクリックされるたびに`table.getCellEditor(row, col).stopCellEditing();`を呼び出しています。~~



### 参考リンク
- [JTableのセル中にJRadioButtonを配置](http://terai.xrea.jp/Swing/RadioButtonsInTableCell.html)
- [JTableのセルに複数のJButtonを配置する](http://terai.xrea.jp/Swing/MultipleButtonsInTableCell.html)
- [JCheckBoxのセルをロールオーバーする](http://terai.xrea.jp/Swing/RolloverBooleanRenderer.html)

<!-- dummy comment line for breaking list -->

### コメント
- ビットフラグを`EnumSet`に変更するテスト -- [aterai](http://terai.xrea.jp/aterai.html) 2011-03-01 (火) 14:22:06
    - [JTableの列にEnumSetを使用する](http://terai.xrea.jp/Swing/EnumSet.html)に移動
- `rwx`セルを選択中に<kbd>R</kbd>, <kbd>W</kbd>, <kbd>X</kbd>キーを入力するとチェックが切り替わるように`InputMap, ActionMap`を追加。 -- [aterai](http://terai.xrea.jp/aterai.html) 2011-03-09 (水) 22:33:39
- `Windows`環境で`Aero`効果を有効にしていると？、残像が表示される場合がある？のを修正。 -- [aterai](http://terai.xrea.jp/aterai.html) 2011-11-01 (火) 18:12:50

<!-- dummy comment line for breaking list -->
