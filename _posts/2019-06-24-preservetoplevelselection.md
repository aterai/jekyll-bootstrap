---
layout: post
category: swing
folder: PreserveTopLevelSelection
title: JMenuBar内のJMenuをキャンセルした場合にその選択状態を維持する
tags: [JMenu, JMenuBar, Focus, LookAndFeel]
author: aterai
pubdate: 2019-06-24T15:54:33+09:00
description: JMenuBar直下のJMenuをキャンセルで閉じた場合にその選択状態を維持するかどうかを設定します。
image: https://drive.google.com/uc?id=1T6g79tQY4xA9kVjE53DiRWGIfHgIQs6p
comments: true
---
## 概要
`JMenuBar`直下の`JMenu`をキャンセルで閉じた場合にその選択状態を維持するかどうかを設定します。

{% download https://drive.google.com/uc?id=1T6g79tQY4xA9kVjE53DiRWGIfHgIQs6p %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("Menu.preserveTopLevelSelection", Boolean.TRUE);
</code></pre>

## 解説
上記のサンプルでは、`JMenuBar`直下の`JMenu`から開いた`JPopupMenu`を<kbd>ESC</kbd>キー入力でキャンセルして閉じた場合、その`JMenu`の選択状態を維持するかどうかを切り替えてテストできます。

- `WindowsLookAndFeel`
    - `UIManager.getLookAndFeelDefaults().getBoolean("Menu.preserveTopLevelSelection")`の初期値は`true`
    - `JMenuBar`直下の`JMenu`から開いた`JPopupMenu`をキャンセルで閉じた場合、その`JMenu`の選択状態を維持する
        - この状態でもう一度キャンセルキー(<kbd>ESC</kbd>)を入力すると選択状態はクリアされる
    - マウスクリックでキャンセルした場合は常に`JMenu`の選択状態はクリアされ、`Menu.preserveTopLevelSelection`には影響されない
    - サブメニューをキャンセルした場合は常に`JMenu`の選択状態は維持され、`Menu.preserveTopLevelSelection`には影響されない
- その他の`LookAndFeel`(`MetalLookAndFeel`、`NimbusLookAndFeel`など)
    - `UIManager.getLookAndFeelDefaults().getBoolean("Menu.preserveTopLevelSelection")`の初期値は`false`
    - `JMenuBar`直下の`JMenu`から開いた`JPopupMenu`をキャンセルで閉じた場合、その`JMenu`の選択状態はクリアされる
    - `UIManager.put("Menu.preserveTopLevelSelection", Boolean.TRUE)`を設定すれば、`WindowsLookAndFeel`風に`JMenu`の選択状態が維持される
    - サブメニューをキャンセルした場合は常に`JMenu`の選択状態は維持され、`Menu.preserveTopLevelSelection`には影響されない
        - `MotifLookAndFeel`の場合、サブメニューをキャンセルするとすべての`JPopupMenu`が閉じる
        - `UIManager.put("Menu.cancelMode", "hideLastSubmenu");`で最後の`JPopupMenu`のみ閉じるよう切り替え可能
        - [JMenuから開いたJPopupMenuをキャンセルした場合の動作を変更する](https://ateraimemo.com/Swing/MenuCancelMode.html)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [DisabledなJMenuItemのハイライトをテスト](https://ateraimemo.com/Swing/DisabledAreNavigable.html)
- [JMenuから開いたJPopupMenuをキャンセルした場合の動作を変更する](https://ateraimemo.com/Swing/MenuCancelMode.html)

<!-- dummy comment line for breaking list -->

## コメント
