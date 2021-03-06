---
layout: post
category: swing
folder: AuxiliaryLookAndFeel
title: AuxiliaryLookAndFeelを追加する
tags: [LookAndFeel, AuxiliaryLookAndFeel, UIManager, JComboBox]
author: aterai
pubdate: 2012-04-09T14:26:00+09:00
description: AuxiliaryLookAndFeelを追加して、WindowsLookAndFeelの場合の動作を変更します。
image: https://lh4.googleusercontent.com/-SxIyCqWRFhk/T4JxXw96NSI/AAAAAAAABLQ/gM_5mjZPn1o/s800/AuxiliaryLookAndFeel.png
comments: true
---
## 概要
`AuxiliaryLookAndFeel`を追加して、`WindowsLookAndFeel`の場合の動作を変更します。

{% download https://lh4.googleusercontent.com/-SxIyCqWRFhk/T4JxXw96NSI/AAAAAAAABLQ/gM_5mjZPn1o/s800/AuxiliaryLookAndFeel.png %}

## サンプルコード
<pre class="prettyprint"><code>JCheckBox check = (JCheckBox) e.getSource();
String lnf = UIManager.getLookAndFeel().getName();
if (check.isSelected() &amp;&amp; lnf.contains("Windows")) {
  UIManager.addAuxiliaryLookAndFeel(auxLookAndFeel);
} else {
  UIManager.removeAuxiliaryLookAndFeel(auxLookAndFeel);
}
SwingUtilities.updateComponentTreeUI(getRootPane());
</code></pre>

## 解説
`WindowsLookAndFeel`の場合、それを修正することなく、`JComboBox`のドロップダウンリストで右クリックを無効にするような`ComboBoxUI`を`UIManager.addAuxiliaryLookAndFeel(...)`を使って追加しています。

- [JComboBoxのドロップダウンリストで右クリックを無効化](https://ateraimemo.com/Swing/DisableRightClick.html)

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
    if (cbe != null) {
      editor = cbe.getEditorComponent();
      if (editor != null) {
        configureEditor();
        comboBox.add(editor);
        if (comboBox.isFocusOwner()) {
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
  // ...
</code></pre>

- 注:
    - `LookAndFeel`を`Nimbus`にすると`ClassCastException`が発生する
        - [&#91;JDK-6631956&#93; Nimbus: ClassCastException when running with MultiLookAndFeel - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-6631956)
    - `UIManager.addPropertyChangeListener(new PropertyChangeListener() {...});`を追加して、`WindowsLookAndFeel`以外の場合は、`UIManager.removeAuxiliaryLookAndFeel(auxLookAndFeel);`
    - 編集可能な`JComboBox`の場合、`NullPointerException`が発生する
        - `WindowsComboBoxUI#addEditor()`をオーバーライド

<!-- dummy comment line for breaking list -->

## 参考リンク
- [多重Look & Feelの使用](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/plaf/multi/doc-files/multi_tsc.html)
- [UIManager#addAuxiliaryLookAndFeel(LookAndFeel) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/UIManager.html#addAuxiliaryLookAndFeel-javax.swing.LookAndFeel-)

<!-- dummy comment line for breaking list -->

## コメント
- `AuxiliaryLookAndFeel`の作成方法、使い方などを間違えているような気がするが…。 -- *aterai* 2012-04-09 (月) 14:41:52

<!-- dummy comment line for breaking list -->
