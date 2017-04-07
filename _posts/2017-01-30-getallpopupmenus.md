---
layout: post
category: swing
folder: GetAllPopupMenus
title: MenuSelectionManagerですべてのJPopupMenuを取得する
tags: [JPopupMenu, Focus]
author: aterai
pubdate: 2017-01-30T15:17:50+09:00
description: MenuSelectionManagerですべてのJPopupMenuを取得し、任意のタイミングでそれらを非表示に切り替えます。
image: https://drive.google.com/uc?export=view&id=18mKH-3iW9D0-aw0doM7C-6-hFWoe-JMa7w
comments: true
---
## 概要
`MenuSelectionManager`ですべての`JPopupMenu`を取得し、任意のタイミングでそれらを非表示に切り替えます。

{% download https://drive.google.com/uc?export=view&id=18mKH-3iW9D0-aw0doM7C-6-hFWoe-JMa7w %}

## サンプルコード
<pre class="prettyprint"><code>tabs.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(
    KeyStroke.getKeyStroke(KeyEvent.VK_4, KeyEvent.CTRL_MASK), "next2");
tabs.getActionMap().put("next2", new AbstractAction() {
  @Override public void actionPerformed(ActionEvent e) {
    for (MenuElement m: MenuSelectionManager.defaultManager().getSelectedPath()) {
      if (m instanceof JPopupMenu) {
        ((JPopupMenu) m).setVisible(false);
      }
    }
    tabs.setSelectedIndex((tabs.getSelectedIndex() + 1) % tabs.getTabCount());
  }
});
</code></pre>

## 解説
- <kbd>Ctrl+1</kbd>: `prev1`
    - `JTable`に設定した`JPopupMenu`を開いた状態で、`JTabbedPane`に設定したキー入力(`JComponent.WHEN_IN_FOCUSED_WINDOW`)によるタブ切替アクションを実行すると、`JPopupMenu`が開いたまま前のタブの選択が実行される
    - `requestFocusInWindow()`などでフォーカスを`JTable`以外に移動しても、`JPopupMenu`は閉じない
- <kbd>Ctrl+2</kbd>: `next1`
    - `JTable`に設定した`JPopupMenu`を開いた状態(`JPopupMenu`にフォーカスがある)の場合、`JTabbedPane`に設定したキー入力(`JComponent.WHEN_FOCUSED`)によるタブ切替アクションは、実行することはできない
- <kbd>Ctrl+3</kbd>: `prev2`
    - `JTabbedPane`に設定したキー入力(`JComponent.WHEN_IN_FOCUSED_WINDOW`)によるタブ切替アクションを実行する場合、直前にダミーのマウスプレスイベント発行してすべての`JPopupMenu`を閉じる
- <kbd>Ctrl+4</kbd>: `next2`
    - `JTabbedPane`に設定したキー入力(`JComponent.WHEN_IN_FOCUSED_WINDOW`)によるタブ切替アクションを実行する場合、`MenuSelectionManager#getSelectedPath()`ですべての`JPopupMenu`を取得し、`JPopupMenu#setVisible(false)`で非表示にする
    - 参考: `javax/swing/plaf/basic/BasicPopupMenuUI.java`の`List<JPopupMenu> getPopups()`メソッド

<!-- dummy comment line for breaking list -->

- - - -
- 以下のように`LayeredPane#getComponentsInLayer(JLayeredPane.POPUP_LAYER)`で表示中の`JPopupMenu`を取得する方法も存在するが、これは`JFrame`の外に表示される場合の`HeavyWeightWindow`を使用した`JPopupMenu`が取得できない
    
    <pre class="prettyprint"><code>JLayeredPane lp = ((JFrame) tabs.getTopLevelAncestor()).getLayeredPane();
    for (Component c: lp.getComponentsInLayer(JLayeredPane.POPUP_LAYER)) {
      for (Component p: ((Container) c).getComponents()) {
        if (p instanceof JPopupMenu) {
          p.setVisible(false);
        }
      }
    }
</code></pre>
- * 参考リンク [#reference]
- [java - JPopupMenu not closing on keyevent - Stack Overflow](https://stackoverflow.com/questions/41867173/jpopupmenu-not-closing-on-keyevent)

<!-- dummy comment line for breaking list -->

## コメント
