---
layout: post
category: swing
folder: DividerFocus
title: JSplitPaneのDividerをマウスクリックで選択状態にする
tags: [JSplitPane]
author: aterai
pubdate: 2020-05-11T17:50:27+09:00
description: JSplitPaneのDividerをマウスでクリックしたとき選択状態になるよう設定します。
image: https://drive.google.com/uc?id=1KMTrAVDblIUSfTjTvu0s_fBYMckaaF9Z
comments: true
---
## 概要
`JSplitPane`の`Divider`をマウスでクリックしたとき選択状態になるよう設定します。

{% download https://drive.google.com/uc?id=1KMTrAVDblIUSfTjTvu0s_fBYMckaaF9Z %}

## サンプルコード
<pre class="prettyprint"><code>JSplitPane splitPane = new JSplitPane();
Container divider = ((BasicSplitPaneUI) splitPane.getUI()).getDivider();
divider.addMouseListener(new MouseAdapter() {
  @Override public void mousePressed(MouseEvent e) {
    super.mousePressed(e);
    splitPane.requestFocusInWindow();
    // or
    // Action startResize = splitPane.getActionMap().get("startResize");
    // startResize.actionPerformed(new ActionEvent(
    //     splitPane, ActionEvent.ACTION_PERFORMED, "startResize"));
  }
});
</code></pre>

## 解説
- `Default`
    - デフォルトの`JSplitPane`では`Divider`をクリックしてもフォーカス移動は発生しない
    - <kbd>F8</kbd>キーを押して`startResize`アクションを実行しないと`Divider`は選択状態にならず、カーソルキーでの`Divider`移動は不可
    - `JSplitPane`とその子コンポーネントがすべてフォーカス不可の場合、`Divider`を選択状態にすることはできない
        - `JSplitPane#setFocusable(true)`を設定すれば<kbd>Tab</kbd>キーなどで`Divider`を選択状態にできる
- `Divider.addMouseListener`
    - `BasicSplitPaneUI#getDivider()`で取得した`Divider`に`MouseListener`を設定して、クリックされたら親の`JSplitPane`にフォーカスを移動することで`Divider`を選択状態にする
    - `Container`である`Divider`に`requestFocusInWindow()`を実行することは可能だが、これを実行しても`Divider`は選択状態にならない
        - `JSplitPane`とその子コンポーネントがすべてフォーカス不可でも`Divider`を選択状態にできる

<!-- dummy comment line for breaking list -->

- - - -
- メモ: カーソルキーによる`Divider`の移動量を変更したい
    - `BasicSplitPaneUI.KEYBOARD_DIVIDER_MOVE_OFFSET`が定義されているがどこからも使用されていない？
    - `BasicSplitPaneUI#getKeyboardMoveIncrement()`メソッドが存在してマジックナンバーで`3`が返される
        - これをオーバーライドして移動量を変更したいが、パッケージプライベートなので利用しづらい

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JSplitPaneのDividerをマウスで移動できないように設定する](https://ateraimemo.com/Swing/FixedDividerSplitPane.html)

<!-- dummy comment line for breaking list -->

## コメント
