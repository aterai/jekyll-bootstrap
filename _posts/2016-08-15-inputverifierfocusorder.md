---
layout: post
category: swing
folder: InputVerifierFocusOrder
title: InputVerifierを設定したコンポーネントのフォーカスナビゲーションをテストする
tags: [JTextField, InputVerifier, FocusTraversalPolicy, FocusListener]
author: aterai
pubdate: 2016-08-15T02:09:37+09:00
description: InputVerifierを設定したコンポーネントの入力の検証とフォーカス移動イベントの順番をテストします。
image: https://drive.google.com/uc?export=view&id=19ojUQl6rF4StwHNdQO_xPRlqnkOognwULw
comments: true
---
## 概要
`InputVerifier`を設定したコンポーネントの入力の検証とフォーカス移動イベントの順番をテストします。

{% download https://drive.google.com/uc?export=view&id=19ojUQl6rF4StwHNdQO_xPRlqnkOognwULw %}

## サンプルコード
<pre class="prettyprint"><code>JTextField textField = new JTextField(24);
textField.setInputVerifier(new InputVerifier() {
  @Override public boolean verify(JComponent c) {
    if (c instanceof JTextComponent) {
      JTextComponent tc = (JTextComponent) c;
      String str = tc.getText().trim();
      return !str.isEmpty() &amp;&amp; MAX_LEN - str.length() &gt;= 0;
    }
    return false;
  }
  @Override public boolean shouldYieldFocus(JComponent input) {
    System.out.println("shouldYieldFocus");
    if (isAllValid()) {
      button.setEnabled(true);
      //EventQueue.invokeLater(() -&gt; button.requestFocusInWindow());
    } else {
      button.setEnabled(false);
    }
    return super.shouldYieldFocus(input);
  }
});
setFocusTraversalPolicy(new LayoutFocusTraversalPolicy() {
  @Override public Component getComponentAfter(
      Container focusCycleRoot, Component aComponent) {
    System.out.println("getComponentAfter");
    button.setEnabled(isAllValid());
    return super.getComponentAfter(focusCycleRoot, aComponent);
  }
  @Override public Component getComponentBefore(
      Container focusCycleRoot, Component aComponent) {
    System.out.println("getComponentAfter");
    button.setEnabled(isAllValid());
    return super.getComponentBefore(focusCycleRoot, aComponent);
  }
});
setFocusCycleRoot(true);
</code></pre>

## 解説
上記のサンプルでは、パネル内の`JTextField`がすべて入力検証に成功した場合、`JButton`をクリック可能に更新する`UI`のテストを行っています。

- <kbd>Tab</kbd>キーを押してフォーカス移動するとき、すべての`JTextField`がすべて入力検証に成功する場合は、`JButton`をクリック可能に更新し、`JButton`にフォーカスを移動し、すぐに<kbd>Space</kbd>キーなどでクリックしたい
- `InputVerifier#shouldYieldFocus(...)`や`FocusListener#focusLost(...)`で、`JButton#setEnabled(true)`としても、フォーカスは`JButton`に移動しない(初めて`JButton`がクリック可能になったときは、先頭の`JCheckBox`にフォーカスが移動する)
    - これらの実行より先に`LayoutFocusTraversalPolicy#getComponentAfter(...)`で、次にフォーカスが移動するコンポーネントが決定されるため、この時点で`JButton#setEnabled(true)`になっていない`JButton`はスキップされる
- 回避方法:
    - `InputVerifier#shouldYieldFocus(...)`や`FocusListener#focusLost(...)`内で、`EventQueue.invokeLater(() -> button.requestFocusInWindow() );`などを実行し、一番後でフォーカスを強制的に`JButton`に移動する
    - または、`LayoutFocusTraversalPolicy#getComponentAfter(...)`をオーバーライドして、事前に`JButton#setEnabled(true)`を実行する

<!-- dummy comment line for breaking list -->

## コメント
