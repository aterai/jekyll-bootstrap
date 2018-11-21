---
layout: post
category: swing
folder: ComboBoxItemCopy
title: JComboBoxのItemをキー入力やJPopupMenuでコピーする
tags: [JComboBox, JPopupMenu, ActionMap, InputMap]
author: aterai
pubdate: 2018/11/19T16:40:06+09:00
description: JComboBoxのItemをキー入力やJPopupMenuを使用してコピーします。
image: https://drive.google.com/uc?id=1NdGJia5hxUObZKEOuG1aS83TzDZvfjOpXQ
comments: true
---
## 概要
`JComboBox`の`Item`をキー入力や`JPopupMenu`を使用してコピーします。

{% download https://drive.google.com/uc?id=1NdGJia5hxUObZKEOuG1aS83TzDZvfjOpXQ %}

## サンプルコード
<pre class="prettyprint"><code>JComboBox&lt;String&gt; combo1 = new JComboBox&lt;&gt;(makeModel(5));
Action copy = new AbstractAction() {
  @Override public void actionPerformed(ActionEvent e) {
    JComboBox&lt;?&gt; combo = (JComboBox&lt;?&gt;) e.getSource();
    Optional.ofNullable(combo.getSelectedItem()).ifPresent(text -&gt; {
      Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
      Transferable contents = new StringSelection(Objects.toString(text));
      clipboard.setContents(contents, null);
      System.out.println(text);
    });
  }
};
ActionMap am = combo1.getActionMap();
am.put(COPY_KEY, copy);
int modifiers = InputEvent.CTRL_DOWN_MASK;
KeyStroke keyStroke = KeyStroke.getKeyStroke(KeyEvent.VK_C, modifiers);
InputMap im = combo1.getInputMap(JComponent.WHEN_FOCUSED);
im.put(keyStroke, COPY_KEY);
JPopupMenu popup = new JPopupMenu();
popup.add(COPY_KEY).addActionListener(e -&gt; {
  Object o = popup.getInvoker();
  Container c = o instanceof JComboBox ? (Container) o
    : SwingUtilities.getAncestorOfClass(JComboBox.class, (Component) o);
  if (c instanceof JComboBox) {
    JComboBox&lt;?&gt; combo = (JComboBox&lt;?&gt;) c;
    Action a = combo.getActionMap().get(COPY_KEY);
    a.actionPerformed(new ActionEvent(combo, e.getID(), e.getActionCommand()));
    // KeyEvent keyEvent = new KeyEvent(combo, 0, 0, 0, 0, 'C');
    // SwingUtilities.notifyAction(a, keyStroke, keyEvent, combo, modifiers);
  }
});
combo1.setComponentPopupMenu(popup);
</code></pre>

## 解説
- `Default:`
    - デフォルトでは編集不可の`JComboBox`に<kbd>Ctrl+C</kbd>などのキー入力でのコピー機能はない
- `Editable: false, JPopupMenu, Ctrl+C`
    - 編集不可の`JComboBox`に`ActionMap`、`InputMap`を使用して<kbd>Ctrl+C</kbd>キーで現在選択中のアイテム文字列をコピー可能に設定
    - `JComboBox#setComponentPopupMenu(...)`で`ActionMap`に追加したコピーイベントを呼び出せるよう設定
        - `JComboBox`のボタン上で`JPopupMenu`を呼び出すと`JPopupMenu#getInvoker()`で`JButton`が返るので注意が必要
- `Editable: true, JPopupMenu, Ctrl+C`
    - `JComboBox#getEditor().getEditorComponent()`で取得した`JTextField`に`JTextField#setComponentPopupMenu(...)`でコピーなどを実行する`JPopupMenu`を設定
    - `JTextField`はデフォルトで<kbd>Ctrl+C</kbd>キーなどでのコピーが可能

<!-- dummy comment line for breaking list -->

## 参考リンク
- [swing - Copy text in combo-box Java - Stack Overflow](https://stackoverflow.com/questions/52731102/copy-text-in-combo-box-java)
- [DefaultEditorKitでポップアップメニューからコピー](https://ateraimemo.com/Swing/DefaultEditorKit.html)
- [JPopupMenuを開く前に対象となるJTextFieldにFocusを移動する](https://ateraimemo.com/Swing/FocusBeforePopup.html)

<!-- dummy comment line for breaking list -->

## コメント
