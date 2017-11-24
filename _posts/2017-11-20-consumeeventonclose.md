---
layout: post
category: swing
folder: ConsumeEventOnClose
title: JPopupMenuを開いた状態で別コンポーネントをクリックした場合のイベントを実行するかを切り替える
tags: [JPopupMenu, UIManager, LookAndFeel]
author: aterai
pubdate: 2017-11-20T15:20:31+09:00
description: JPopupMenuを閉じるイベントが別コンポーネントをクリックすることで発生したとき、コンポーネントのクリックイベントを実行するかどうかを切り替えます。
image: https://drive.google.com/uc?export=view&id=1hqQoBKoHLGEqyn7rHxhKsyo-HBHiKTwAEQ
comments: true
---
## 概要
`JPopupMenu`を閉じるイベントが別コンポーネントをクリックすることで発生したとき、コンポーネントのクリックイベントを実行するかどうかを切り替えます。

{% download https://drive.google.com/uc?export=view&id=1hqQoBKoHLGEqyn7rHxhKsyo-HBHiKTwAEQ %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("PopupMenu.consumeEventOnClose", false);
</code></pre>

## 解説
- `PopupMenu.consumeEventOnClose`: `true`
    - `JPopupMenu`を閉じるイベントが別コンポーネントをクリックすることで発生したとき、コンポーネントのクリックイベントを実行しない
    - `WindowsLookAndFeel`や`NimbusLookAndFeel`のデフォルト
    - 例:
        - `JPopupMenu`を開いた状態で`Beep`ボタンをクリックしても`Beep`音は鳴らない
        - `JPopupMenu`を開いた状態で`JTextField`をクリックしてもフォーカスは移動しない
        - `JToolBar`を分離して別ウィンドウで`JPopupMenu`開いた状態でも、この動作は変わらない
        - `JComboBox`は例外で、ドロップダウンリストは開き、コンボエディタにフォーカスは移動する
        - `JComboBox`のドロップダウンリストを開いた状態で`Beep`ボタンをクリックしても`Beep`音は鳴らない
        - 参考: [JPopupMenuを開く前に対象となるJTextFieldにFocusを移動する](https://ateraimemo.com/Swing/FocusBeforePopup.html)
- `PopupMenu.consumeEventOnClose`: `false`
    - `JPopupMenu`を閉じるイベントが別コンポーネントをクリックすることで発生したとき、コンポーネントのクリックイベントを実行する
    - `MetalLookAndFeel`のデフォルト
    - 例:
        - `JPopupMenu`を開いた状態で`Beep`ボタンをクリックすると`Beep`音が鳴る
        - `JPopupMenu`を開いた状態で`JComboBox`のコンボエディタをクリックしても`JPopupMenu`は表示を維持する
        - `JToolBar`を分離し別ウィンドウで`JPopupMenu`開いた状態の場合、`JComboBox`のコンボエディタをクリックするとフォーカスが移動して`JPopupMenu`は非表示になる

<!-- dummy comment line for breaking list -->

## 参考リンク
- [java - Changing nimbus JPopupmenu behaviour - Stack Overflow](https://stackoverflow.com/questions/34679216/changing-nimbus-jpopupmenu-behaviour)
- [JDK-6770445 Unable to transfer focus with single click when the combobox popup is visible - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-6770445)
- [JToggleButtonからポップアップメニューを開く](https://ateraimemo.com/Swing/ToolButtonPopup.html)

<!-- dummy comment line for breaking list -->

## コメント
