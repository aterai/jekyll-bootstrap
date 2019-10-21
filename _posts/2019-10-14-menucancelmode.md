---
layout: post
category: swing
folder: MenuCancelMode
title: JMenuから開いたJPopupMenuをキャンセルした場合の動作を変更する
tags: [JMenu, JPopupMenu, LookAndFeel, UIManager]
author: aterai
pubdate: 2019-10-14T03:01:26+09:00
description: JMenuから開いたJPopupMenuをキャンセルした場合、カレントのサブメニューから閉じるか、すべてのメニューツリーを閉じるかを設定します。
image: https://drive.google.com/uc?id=1KMgWDSQkZS95tcgDW87x4bzZd4_M3mdV
comments: true
---
## 概要
`JMenu`から開いた`JPopupMenu`をキャンセルした場合、カレントのサブメニューから閉じるか、すべてのメニューツリーを閉じるかを設定します。

{% download https://drive.google.com/uc?id=1KMgWDSQkZS95tcgDW87x4bzZd4_M3mdV %}

## サンプルコード
<pre class="prettyprint"><code>String key = "Menu.cancelMode";

String cancelMode = UIManager.getString(key);
System.out.println(key + ": " + cancelMode);
boolean defaultMode = "hideMenuTree".equals(cancelMode);
JRadioButton hideMenuTreeRadio = makeRadioButton("hideMenuTree", defaultMode);
JRadioButton hideLastSubmenuRadio = makeRadioButton("hideLastSubmenu", !defaultMode);

Box box = Box.createHorizontalBox();
box.setBorder(BorderFactory.createTitledBorder(key));
ItemListener handler = e -&gt; {
  if (e.getStateChange() == ItemEvent.SELECTED) {
    JRadioButton r = (JRadioButton) e.getSource();
    UIManager.put(key, r.getText());
  }
};
ButtonGroup bg = new ButtonGroup();
Stream.of(hideLastSubmenuRadio, hideMenuTreeRadio).forEach(r -&gt; {
  r.addItemListener(handler);
  bg.add(r);
  box.add(r);
});
add(box);
</code></pre>

## 解説
- `UIManager.put("Menu.cancelMode", "hideLastSubmenu");`
    - <kbd>ESC</kbd>キー入力によるキャンセルでメニューツリーの最後に開かれた`JPopupMenu`のみ閉じる
    - `BasicLookAndFeel`、`MetalLookAndFeel`、`WindowsLookAndFeel`などのデフォルト
- `UIManager.put("Menu.cancelMode", "hideMenuTree");`
    - <kbd>ESC</kbd>キー入力によるキャンセルですべてのメニューツリーの`JPopupMenu`を閉じる
    - `MotifLookAndFeel`、`GTKLookAndFeel`のデフォルト

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JMenuBar内のJMenuをキャンセルした場合にその選択状態を維持する](https://ateraimemo.com/Swing/PreserveTopLevelSelection.html)

<!-- dummy comment line for breaking list -->

## コメント
