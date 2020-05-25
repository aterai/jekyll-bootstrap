---
layout: post
category: swing
folder: DisabledOkButtonOptionPane
title: JOptionPaneのOKボタンを文字列が入力されるまで選択不可に設定する
tags: [JOptionPane, DefaultButton, JTextField, DocumentListener]
author: aterai
pubdate: 2020-04-13T00:57:30+09:00
description: JOptionPaneのConfirmDialogに表示されるOKボタンを文字列が入力されるまで選択不可に設定します。
image: https://drive.google.com/uc?id=1blPT1pPi2dsuRd88JceWb8mITDHT9Yd1
hreflang:
    href: https://java-swing-tips.blogspot.com/2020/05/disable-joptionpane-ok-button-until.html
    lang: en
comments: true
---
## 概要
`JOptionPane`の`ConfirmDialog`に表示される`OK`ボタンを文字列が入力されるまで選択不可に設定します。

{% download https://drive.google.com/uc?id=1blPT1pPi2dsuRd88JceWb8mITDHT9Yd1 %}

## サンプルコード
<pre class="prettyprint"><code>JPanel panel2 = new JPanel(new GridLayout(2, 1));
JTextField field2 = new JTextField();
Border enabledBorder = field2.getBorder();
Insets i = enabledBorder.getBorderInsets(field2);
Border disabledBorder = BorderFactory.createCompoundBorder(
    BorderFactory.createLineBorder(Color.RED),
    BorderFactory.createEmptyBorder(i.top - 1, i.left - 1, i.bottom - 1, i.right - 1));
String disabledMessage = "Text is required to create ...";
JLabel label2 = new JLabel(" ");
label2.setForeground(Color.RED);
panel2.add(field2);
panel2.add(label2);
if (field2.getText().isEmpty()) {
  field2.setBorder(disabledBorder);
  label2.setText(disabledMessage);
}
field2.addHierarchyListener(e -&gt; {
  Component c = e.getComponent();
  if ((e.getChangeFlags() &amp; HierarchyEvent.SHOWING_CHANGED) != 0 &amp;&amp; c.isShowing()) {
    EventQueue.invokeLater(c::requestFocusInWindow);
  }
});
field2.getDocument().addDocumentListener(new DocumentListener() {
  private void update() {
    boolean verified = !field2.getText().isEmpty();
    JButton b = field2.getRootPane().getDefaultButton();
    if (verified) {
      b.setEnabled(true);
      field2.setBorder(enabledBorder);
      label2.setText(" ");
    } else {
      b.setEnabled(false);
      field2.setBorder(disabledBorder);
      label2.setText(disabledMessage);
    }
  }

  @Override public void insertUpdate(DocumentEvent e) {
    update();
  }

  @Override public void removeUpdate(DocumentEvent e) {
    update();
  }

  @Override public void changedUpdate(DocumentEvent e) {
    update();
  }
});
JButton button2 = new JButton("show");
button2.addActionListener(e -&gt; {
  Component p2 = log.getRootPane();
  EventQueue.invokeLater(() -&gt; {
    JButton b = field2.getRootPane().getDefaultButton();
    if (b != null &amp;&amp; field2.getText().isEmpty()) {
      b.setEnabled(false);
    }
  });
  int ret = JOptionPane.showConfirmDialog(
      p2, panel2, "Input text", JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
  if (ret == JOptionPane.OK_OPTION) {
    log.setText(field2.getText());
  }
});
</code></pre>

## 解説
- 文字列入力用の`JTextField`を作成
- `HierarchyListener`を`JTextField`に追加し、`ConfirmDialog`が開いたときの初期フォーカスをデフォルトボタンからこの`JTextField`に移動
    - [JOptionPaneのデフォルトフォーカス](https://ateraimemo.com/Swing/OptionPaneDefaultFocus.html)
- `DocumentListener`を`JTextField`のドキュメントに追加し、`JTextField`に入力があれば`OK`ボタンの選択可・不可を切り替える
    - `ConfirmDialog`の`OK`ボタンは`JTextField#getRootPane()#getDefaultButton()`などで取得可能
    - このサンプルでは`JTextField`の`Border`なども切り替えている
- `JOptionPane.showConfirmDialog(...)`のメッセージに`JTextField`を含むコンポーネントを設定して`ConfirmDialog`を開く

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JOptionPaneのデフォルトフォーカス](https://ateraimemo.com/Swing/OptionPaneDefaultFocus.html)

<!-- dummy comment line for breaking list -->

## コメント
