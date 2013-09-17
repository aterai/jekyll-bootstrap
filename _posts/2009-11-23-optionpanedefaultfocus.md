---
layout: post
title: JOptionPaneのデフォルトフォーカス
category: swing
folder: OptionPaneDefaultFocus
tags: [JOptionPane, Focus, JComponent, WindowListener, HierarchyListener, AncestorListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-11-23

## JOptionPaneのデフォルトフォーカス
`JOptionPane`にデフォルトでフォーカスをもつコンポーネントを追加します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTQoUaDrDI/AAAAAAAAAf4/nUnrCrmb5io/s800/OptionPaneDefaultFocus.png)

### サンプルコード
<pre class="prettyprint"><code>textField4.addAncestorListener(new AncestorListener() {
  @Override public void ancestorAdded(AncestorEvent e) {
    e.getComponent().requestFocusInWindow();
    //or textField4.requestFocusInWindow();
  }
  @Override public void ancestorMoved(AncestorEvent e) {}
  @Override public void ancestorRemoved(AncestorEvent e) {}
});
</code></pre>

### 解説
上記のサンプルでは、`JOptionPane.showConfirmDialog`で表示する`JTextField`にデフォルトのフォーカスがあたるように設定しています。

- 左上
    - デフォルト

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>int result = JOptionPane.showConfirmDialog(frame, textField, "Input Text",
                 JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
if(result==JOptionPane.OK_OPTION) textArea.setText(textField.getText());
</code></pre>

- 右上
    - `JOptionPane#createDialog(...)`で`JDialog`を取得し、`WindowListener#windowOpened`で、`textField.requestFocusInWindow();`
    - [Windowを開いたときのフォーカスを指定](http://terai.xrea.jp/Swing/DefaultFocus.html)など

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>JOptionPane pane = new JOptionPane(textField, JOptionPane.PLAIN_MESSAGE,
                                   JOptionPane.OK_CANCEL_OPTION, null, null, null);
JDialog dialog = pane.createDialog(frame, "Input Text");
dialog.addWindowListener(new WindowAdapter() {
  @Override public void windowOpened(WindowEvent e) {
    textField.requestFocusInWindow();
  }
});
dialog.setVisible(true);
Object selectedValue = pane.getValue();
int result = JOptionPane.CLOSED_OPTION;
if(selectedValue != null &amp;&amp; selectedValue instanceof Integer) {
  result = ((Integer)selectedValue).intValue();
}
result==JOptionPane.OK_OPTION) textArea.setText(textField.getText());
</code></pre>

- 左下
    - `textField`に`HierarchyListener`を追加し、`hierarchyChanged`が呼ばれたときに、`textField.requestFocusInWindow();`

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>textField3.addHierarchyListener(new HierarchyListener() {
  @Override public void hierarchyChanged(HierarchyEvent e) {
    if((e.getChangeFlags() &amp; HierarchyEvent.SHOWING_CHANGED)!=0
       &amp;&amp; textField3.isShowing()) {
      EventQueue.invokeLater(new Runnable(){
        @Override public void run() {
          textField3.requestFocusInWindow();
        }
      });
    }
  }
});
int result = JOptionPane.showConfirmDialog(frame, textField3, "Input Text",
                 JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
if(result==JOptionPane.OK_OPTION) textArea.setText(textField3.getText());
</code></pre>

- 右下
    - `textField`に`addAncestorListener`を追加し、`ancestorAdded`が呼ばれたときに、`textField.requestFocusInWindow();`
    - [Swing - Input focus](https://forums.oracle.com/thread/1354218)

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Windowを開いたときのフォーカスを指定](http://terai.xrea.jp/Swing/DefaultFocus.html)
- [Swing - Input focus](https://forums.oracle.com/thread/1354218)

<!-- dummy comment line for breaking list -->

### コメント
