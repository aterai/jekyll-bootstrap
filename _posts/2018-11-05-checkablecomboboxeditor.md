---
layout: post
category: swing
folder: CheckableComboBoxEditor
title: JComboBoxのComboBoxEditorに編集可能なJCheckBoxを追加する
tags: [JComboBox, ComboBoxEditor, JCheckBox]
author: aterai
pubdate: 2018-11-05T16:25:10+09:00
description: JComboBoxを編集可能に設定し、ComboBoxEditorとして複数のJCheckBoxとJTextFieldを配置したJPanelを設定します。
image: https://drive.google.com/uc?id=1f3vhPqkXg-Jg6AK0p01Pn7aGRTo-Wlv0pw
comments: true
---
## 概要
`JComboBox`を編集可能に設定し、`ComboBoxEditor`として複数の`JCheckBox`と`JTextField`を配置した`JPanel`を設定します。

{% download https://drive.google.com/uc?id=1f3vhPqkXg-Jg6AK0p01Pn7aGRTo-Wlv0pw %}

## サンプルコード
<pre class="prettyprint"><code>class CheckComboBoxEditor implements ComboBoxEditor {
  private final EditorPanel editor = new EditorPanel(new ComboItem());
  @Override public void selectAll() {
    editor.selectAll();
  }
  @Override public Object getItem() {
    return editor.getItem();
  }
  @Override public void setItem(Object anObject) {
    EventQueue.invokeLater(() -&gt; {
      Container c = SwingUtilities.getAncestorOfClass(
          JComboBox.class, getEditorComponent());
      if (c instanceof JComboBox) {
        JComboBox&lt;?&gt; combo = (JComboBox&lt;?&gt;) c;
        int idx = combo.getSelectedIndex();
        if (idx &gt;= 0 &amp;&amp; idx != editor.getEditingIndex()) {
          System.out.println("setItem: " + idx);
          editor.setEditingIndex(idx);
        }
      }
    });
    if (anObject instanceof ComboItem) {
      editor.setItem((ComboItem) anObject);
    } else {
      editor.setItem(new ComboItem());
    }
  }
  @Override public Component getEditorComponent() {
    return editor;
  }
  @Override public void addActionListener(ActionListener l) {
    editor.addActionListener(l);
  }
  @Override public void removeActionListener(ActionListener l) {
    editor.removeActionListener(l);
  }
}

final class EditorPanel extends JPanel {
  private final JCheckBox enabledCheck = new JCheckBox();
  private final JCheckBox editableCheck = new JCheckBox();
  private final JTextField textField = new JTextField("", 16);
  private final transient ComboItem data;
  private int editingIndex = -1;

  protected EditorPanel(ComboItem data) {
    super();
    this.data = data;
    setItem(data);

    enabledCheck.addActionListener(e -&gt; {
      Container c = SwingUtilities.getAncestorOfClass(JComboBox.class, this);
      if (c instanceof JComboBox) {
        JComboBox&lt;?&gt; combo = (JComboBox&lt;?&gt;) c;
        ComboItem item = (ComboItem) combo.getItemAt(editingIndex);
        item.setEnabled(((JCheckBox) e.getSource()).isSelected());
        editableCheck.setEnabled(item.isEnabled());
        textField.setEnabled(item.isEnabled());
        combo.setSelectedIndex(editingIndex);
      }
    });
    enabledCheck.setOpaque(false);
    enabledCheck.setFocusable(false);

    editableCheck.addActionListener(e -&gt; {
      Container c = SwingUtilities.getAncestorOfClass(JComboBox.class, this);
      if (c instanceof JComboBox) {
        JComboBox&lt;?&gt; combo = (JComboBox&lt;?&gt;) c;
        ComboItem item = (ComboItem) combo.getItemAt(editingIndex);
        item.setEditable(((JCheckBox) e.getSource()).isSelected());
        textField.setEditable(item.isEditable());
        combo.setSelectedIndex(editingIndex);
      }
    });
    editableCheck.setOpaque(false);
    editableCheck.setFocusable(false);

    textField.addActionListener(e -&gt; {
      Container c = SwingUtilities.getAncestorOfClass(JComboBox.class, this);
      if (c instanceof JComboBox) {
        JComboBox&lt;?&gt; combo = (JComboBox&lt;?&gt;) c;
        ComboItem item = (ComboItem) combo.getItemAt(editingIndex);
        item.setText(((JTextField) e.getSource()).getText());
        combo.setSelectedIndex(editingIndex);
      }
    });
    textField.setBorder(BorderFactory.createEmptyBorder());
    textField.setOpaque(false);

    setOpaque(false);
    setLayout(new BoxLayout(this, BoxLayout.LINE_AXIS));

    add(enabledCheck);
    add(editableCheck);
    add(textField);
  }
  public int getEditingIndex() {
    return editingIndex;
  }
  public void setEditingIndex(int idx) {
    this.editingIndex = idx;
  }
  public ComboItem getItem() {
    data.setEnabled(enabledCheck.isSelected());
    data.setEditable(editableCheck.isSelected());
    data.setText(textField.getText());
    return data;
  }
  public void setItem(ComboItem item) {
    enabledCheck.setSelected(item.isEnabled());

    editableCheck.setSelected(item.isEditable());
    editableCheck.setEnabled(item.isEnabled());

    textField.setText(item.getText());
    textField.setEnabled(item.isEnabled());
    textField.setEditable(item.isEditable());
  }
  public void selectAll() {
    textField.requestFocusInWindow();
    textField.selectAll();
  }
  public void addActionListener(ActionListener l) {
    textField.addActionListener(l);
    enabledCheck.addActionListener(l);
    editableCheck.addActionListener(l);
  }
  public void removeActionListener(ActionListener l) {
    textField.removeActionListener(l);
    enabledCheck.removeActionListener(l);
    editableCheck.removeActionListener(l);
  }
}
</code></pre>

## 解説
- `setEditable(false), setRenderer(...)`
    - 編集不可の`JComboBox`にレンダラーとして複数の`JCheckBox`と`JTextField`を配置した`JPanel`を使用
    - 編集不可の`JComboBox`やドロップダウンリストの描画にのみ(このためイベントなどは無効)レンダラーとして設定した`JPanel`が使用される

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>class CheckComboBoxRenderer&lt;E extends ComboItem&gt; implements ListCellRenderer&lt;E&gt; {
  private static final Color SBGC = new Color(100, 200, 255);
  private final EditorPanel renderer = new EditorPanel(new ComboItem());
  @Override public Component getListCellRendererComponent(
      JList&lt;? extends E&gt; list, E value, int index,
      boolean isSelected, boolean cellHasFocus) {
    renderer.setItem(value);
    if (isSelected &amp;&amp; index &gt;= 0) {
      renderer.setOpaque(true);
      renderer.setBackground(SBGC);
    } else {
      renderer.setOpaque(false);
      renderer.setBackground(Color.WHITE);
    }
    return renderer;
  }
}
</code></pre>

- `setEditable(true), setRenderer(...), setEditor(...)`
    - 編集可能な`JComboBox`にレンダラーとエディタとして複数の`JCheckBox`と`JTextField`を配置した`JPanel`を使用
    - 編集可能な`JComboBox`のエディタとして設定した`JPanel`がそのまま使用されるため、`JCheckBox`などに設定した`ActionListener`なども有効
        - 左`JCeckBox`: 右`JCeckBox`と`JTextField`の`setEnabled(...)`を切り替える
        - 右`JCeckBox`: `JTextField`の`setEditable(...)`を切り替える

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JComboBoxのEditorComponentにJButtonを配置](https://ateraimemo.com/Swing/ButtonInComboEditor.html)
- [JComboBoxのアイテムとして表示したJCheckBoxを複数選択する](https://ateraimemo.com/Swing/CheckedComboBox.html)
- [java - Using the ComboBoxEditor interface with Custom JComponent, and allow edit, and display the List - Stack Overflow](https://stackoverflow.com/questions/53037906/using-the-comboboxeditor-interface-with-custom-jcomponent-and-allow-edit-and-d)

<!-- dummy comment line for breaking list -->

## コメント
