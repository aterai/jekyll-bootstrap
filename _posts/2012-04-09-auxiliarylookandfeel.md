---
layout: post
title: AuxiliaryLookAndFeelを追加する
category: swing
folder: AuxiliaryLookAndFeel
tags: [LookAndFeel, UIManager, JComboBox]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-04-09

## AuxiliaryLookAndFeelを追加する
`AuxiliaryLookAndFeel`を追加して、`WindowsLookAndFeel`の場合の動作を変更します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/-SxIyCqWRFhk/T4JxXw96NSI/AAAAAAAABLQ/gM_5mjZPn1o/s800/AuxiliaryLookAndFeel.png)

### サンプルコード
<pre class="prettyprint"><code>JCheckBox check = (JCheckBox)e.getSource();
String lnf = UIManager.getLookAndFeel().getName();
if(check.isSelected() &amp;&amp; lnf.contains("Windows")) {
  UIManager.addAuxiliaryLookAndFeel(auxLookAndFeel);
}else{
  UIManager.removeAuxiliaryLookAndFeel(auxLookAndFeel);
}
SwingUtilities.updateComponentTreeUI(MainPanel.this);
</code></pre>

### 解説
`WindowsLookAndFeel`の場合、`JComboBox`のドロップダウンリストで右クリックを無効にするような`ComboBoxUI`を`UIManager.addAuxiliaryLookAndFeel(...)`を使って追加しています。

- [JComboBoxのドロップダウンリストで右クリックを無効化](http://terai.xrea.jp/Swing/DisableRightClick.html)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>public class AuxiliaryWindowsComboBoxUI extends WindowsComboBoxUI {
  public static ComponentUI createUI(JComponent c) {
    return new AuxiliaryWindowsComboBoxUI();
  }
  @Override protected ComboPopup createPopup() {
    return new BasicComboPopup2(comboBox);
  }
  @Override public void addEditor() {
    removeEditor();
    ComboBoxEditor cbe = comboBox.getEditor();
    if(cbe != null) {
      editor = cbe.getEditorComponent();
      if(editor != null) {
        configureEditor();
        comboBox.add(editor);
        if(comboBox.isFocusOwner()) {
          editor.requestFocusInWindow();
        }
      }
    }
  }
  //Override all UI-specific methods your UI classes inherit.
  @Override public void removeEditor() {}
  @Override protected void configureEditor() {}
  @Override protected void unconfigureEditor() {}
  @Override public void update(Graphics g, JComponent c) {}
  @Override public void paint(Graphics g, JComponent c) {}
  //...
</code></pre>

- 注
    - `LookAndFeel`を`Nimbus`にすると`ClassCastException`が発生する
        - [Bug ID: 6631956 Nimbus: ClassCastException when running with MultiLookAndFeel](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6631956)
    - `UIManager.addPropertyChangeListener(new PropertyChangeListener() {...});`を追加して、`WindowsLookAndFeel`以外の場合は、`UIManager.removeAuxiliaryLookAndFeel(auxLookAndFeel);`
    - 編集可能な`JComboBox`の場合、`NullPointerException`が発生する
        - `WindowsComboBoxUI#addEditor()`をオーバーライド

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Using the Multiplexing Look and Feel](http://docs.oracle.com/javase/7/docs/api/javax/swing/plaf/multi/doc-files/multi_tsc.html)

<!-- dummy comment line for breaking list -->

### コメント
- いつか修正: `AuxiliaryLookAndFeel`の作成方法、使い方などをいろいろ間違えているような気がする…。 -- [aterai](http://terai.xrea.jp/aterai.html) 2012-04-09 (月) 14:41:52

<!-- dummy comment line for breaking list -->
