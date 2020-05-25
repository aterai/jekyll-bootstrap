---
layout: post
category: swing
folder: LabelForRequestFocus
title: JLabelがクリックされたらこれに割り当てられているコンポーネントにフォーカスを移動する
tags: [JLabel, Focus, MouseListener]
author: aterai
pubdate: 2020-05-25T18:25:26+09:00
description: JLabelがマウスでクリックされたらこのラベルに割り当てられているコンポーネントにフォーカスを移動します。
image: https://drive.google.com/uc?id=1BInMW2eZh0dX_W7qu-ZUCa11qjYC3woq
comments: true
---
## 概要
`JLabel`がマウスでクリックされたらこのラベルに割り当てられているコンポーネントにフォーカスを移動します。

{% download https://drive.google.com/uc?id=1BInMW2eZh0dX_W7qu-ZUCa11qjYC3woq %}

## サンプルコード
<pre class="prettyprint"><code>MouseListener focusHandler = new MouseAdapter() {
  @Override public void mouseClicked(MouseEvent e) {
    Component c = ((JLabel) e.getComponent()).getLabelFor();
    if (c != null) {
      c.requestFocusInWindow();
    }
  }
};

JLabel label1 = new JLabel("Mail Address:", SwingConstants.RIGHT);
label1.addMouseListener(focusHandler);
label1.setDisplayedMnemonic('M');
Component textField1 = new JTextField(12);
label1.setLabelFor(textField1);
</code></pre>

## 解説
- `JLabel#setLabelFor(...)`メソッドで`JLabel`にコンポーネントを割り当て
    - ニーモニックがアクティブになるとフォースが割り当てられたコンポーネントに移動
        - 参考: [JLabelに設定したニーモニックでフォーカス移動](https://ateraimemo.com/Swing/LabelForDisplayedMnemonic.html)
    - `JLabel`に`MouseListener`を設定してマウスで`JLabel`がクリックされた場合も同様にフォースを割り当てられたコンポーネントに移動

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JLabelに設定したニーモニックでフォーカス移動](https://ateraimemo.com/Swing/LabelForDisplayedMnemonic.html)

<!-- dummy comment line for breaking list -->

## コメント
