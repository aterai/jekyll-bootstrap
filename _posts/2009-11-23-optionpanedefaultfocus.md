---
layout: post
category: swing
folder: OptionPaneDefaultFocus
title: JOptionPaneのデフォルトフォーカス
tags: [JOptionPane, Focus, JComponent, WindowListener, HierarchyListener, AncestorListener]
author: aterai
pubdate: 2009-11-23T19:41:03+09:00
description: JOptionPaneにデフォルトでフォーカスをもつコンポーネントを追加します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTQoUaDrDI/AAAAAAAAAf4/nUnrCrmb5io/s800/OptionPaneDefaultFocus.png
comments: true
---
## 概要
`JOptionPane`にデフォルトでフォーカスをもつコンポーネントを追加します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTQoUaDrDI/AAAAAAAAAf4/nUnrCrmb5io/s800/OptionPaneDefaultFocus.png %}

## サンプルコード
<pre class="prettyprint"><code>textField4.addAncestorListener(new AncestorListener() {
  @Override public void ancestorAdded(AncestorEvent e) {
    e.getComponent().requestFocusInWindow();
  }

  @Override public void ancestorMoved(AncestorEvent e) {
    /* not needed */
  }

  @Override public void ancestorRemoved(AncestorEvent e) {
    /* not needed */
  }
});
</code></pre>

## 解説
上記のサンプルでは、`JOptionPane.showConfirmDialog`で表示する`JTextField`にデフォルトのフォーカスがあたるように設定しています。

- 左上: `Default`
    - デフォルトの`ConfirmDialog`の場合、初期フォーカスは入力欄ではなく`OK`ボタンにある
        
        <pre class="prettyprint"><code>int result = JOptionPane.showConfirmDialog(
            frame, textField, "Input Text",
            JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
        if (result == JOptionPane.OK_OPTION) {
          textArea.setText(textField.getText());
        }
</code></pre>
- 右上: `WindowListener`
    - `JOptionPane#createDialog(...)`で`JDialog`を取得し、`WindowListener#windowOpened`で`textField.requestFocusInWindow();`を実行
    - [Windowを開いたときのフォーカスを指定](https://ateraimemo.com/Swing/DefaultFocus.html)など
        
        <pre class="prettyprint"><code>JOptionPane pane = new JOptionPane(
            textField, JOptionPane.PLAIN_MESSAGE,
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
        if (selectedValue != null &amp;&amp; selectedValue instanceof Integer) {
          result = ((Integer) selectedValue).intValue();
        }
        if (result == JOptionPane.OK_OPTION) {
          textArea.setText(textField.getText());
        }
</code></pre>
- 左下: `HierarchyListener`
    - `textField`に`HierarchyListener`を追加し、`hierarchyChanged`が呼ばれたときに`textField.requestFocusInWindow();`を実行
        
        <pre class="prettyprint"><code>textField3.addHierarchyListener(new HierarchyListener() {
          @Override public void hierarchyChanged(HierarchyEvent e) {
            if ((e.getChangeFlags() &amp; HierarchyEvent.SHOWING_CHANGED) != 0
                 &amp;&amp; textField3.isShowing()) {
              EventQueue.invokeLater(new Runnable() {
                @Override public void run() {
                  textField3.requestFocusInWindow();
                }
              });
            }
          }
        });
        int result = JOptionPane.showConfirmDialog(
            frame, textField3, "Input Text",
            JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
        if (result == JOptionPane.OK_OPTION) {
          textArea.setText(textField3.getText());
        }
</code></pre>
- 右下: `AncestorListener`
    - `textField`に`addAncestorListener`を追加し、`ancestorAdded`が呼ばれたときに`textField.requestFocusInWindow();`を実行
    - [Swing - Input focus](https://community.oracle.com/thread/1354218)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Windowを開いたときのフォーカスを指定](https://ateraimemo.com/Swing/DefaultFocus.html)
- [Swing - Input focus](https://community.oracle.com/thread/1354218)

<!-- dummy comment line for breaking list -->

## コメント
