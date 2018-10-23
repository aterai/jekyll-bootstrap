---
layout: post
category: swing
folder: FixedDividerSplitPane
title: JSplitPaneのDividerをマウスで移動できないように設定する
tags: [JSplitPane, Divider]
author: aterai
pubdate: 2017-09-04T15:18:48+09:00
description: JSplitPaneのDividerをマウスやキー入力などで移動不可になるように設定します。
image: https://drive.google.com/uc?id=1eHpxPFoB6tM1nQoTdo1jYb29F6W2IyIwyw
comments: true
---
## 概要
`JSplitPane`の`Divider`をマウスやキー入力などで移動不可になるように設定します。

{% download https://drive.google.com/uc?id=1eHpxPFoB6tM1nQoTdo1jYb29F6W2IyIwyw %}

## サンプルコード
<pre class="prettyprint"><code>JSplitPane sp = new JSplitPane(...);
sp.setOneTouchExpandable(true);

JCheckBox check1 = new JCheckBox("setEnabled(...)", true);
check1.addActionListener(e -&gt; sp.setEnabled(check1.isSelected()));

int dividerSize = UIManager.getInt("SplitPane.dividerSize");
JCheckBox check2 = new JCheckBox("setDividerSize(0)");
check2.addActionListener(e -&gt; sp.setDividerSize(check2.isSelected() ? 0 : dividerSize));
</code></pre>

## 解説
- `setEnabled(...)`
    - `JSplitPane#setEnabled(false)`を実行して無効化し、マウスやキー入力による`Divider`の移動を不可に設定
    - `JSplitPane`を無効化しても、内部のコンポーネントには影響しない
    - `JSplitPane`を無効化しても、`OneTouch`ボタンは無効化されない
    - `JFrame`のリサイズなどで`JSplitPane`自体のサイズが変化したとき、`ResizeWeight`の値によって`Divider`が移動する場合があるが、`JSplitPane`を無効化してもこれには影響しない
- `setDividerSize(0)`
    - `JSplitPane#setDividerSize(0)`を実行して`Divider`を非表示にし、マウスでの移動を不可に設定
    - カーソルキー入力による移動などは有効
        - `JSplitPane#setFocusable(false)`でキー入力は無効になる
    - `LookAndFeel`に依存し、例えば`MotifLookAndFeel`では`JSplitPane#setDividerSize(0)`を実行しても無効で`Divider`の幅は変化しない

<!-- dummy comment line for breaking list -->

- - - -
- `Component divider = ((BasicSplitPaneUI) sp.getUI() ).getDivider();`で`Divider`を取得し、`setEnabled(false)`を実行しても効果が無い

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JSplitPane (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JSplitPane.html)
- [java - JSplitPane set resizable false - Stack Overflow](https://stackoverflow.com/questions/7065309/jsplitpane-set-resizable-false)

<!-- dummy comment line for breaking list -->

## コメント
