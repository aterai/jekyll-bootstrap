---
layout: post
category: swing
folder: StayOpenCheckBoxMenuItem
title: JCheckBoxMenuItemをクリックしてもJPopupMenuを閉じないように設定する
tags: [JCheckBoxMenuItem, JCheckBox, JPopupMenu]
author: aterai
pubdate: 2016-02-01T01:14:27+09:00
description: JPopupMenuにクリックしてもポップアップが開いたままの状態を維持するように設定したJCheckBoxMenuItemやJCheckBoxを追加します。
image: https://lh3.googleusercontent.com/-hje86Y7xU8k/Vq4umT64DuI/AAAAAAAAOMs/N6gysnrA3e4/s800-Ic42/StayOpenCheckBoxMenuItem.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2016/05/keep-visible-jpopupmenu-while-clicking.html
    lang: en
comments: true
---
## 概要
`JPopupMenu`にクリックしてもポップアップが開いたままの状態を維持するように設定した`JCheckBoxMenuItem`や`JCheckBox`を追加します。

{% download https://lh3.googleusercontent.com/-hje86Y7xU8k/Vq4umT64DuI/AAAAAAAAOMs/N6gysnrA3e4/s800-Ic42/StayOpenCheckBoxMenuItem.png %}

## サンプルコード
<pre class="prettyprint"><code>JMenuItem mi = new JMenuItem(" ");
mi.setLayout(new BorderLayout());
mi.add(new JCheckBox(title) {
  private transient MouseAdapter handler;
  @Override public void updateUI() {
    removeMouseListener(handler);
    removeMouseMotionListener(handler);
    super.updateUI();
    handler = new DispatchParentHandler();
    addMouseListener(handler);
    addMouseMotionListener(handler);
    setFocusable(false);
    setOpaque(false);
  }
});
popup.add(mi);

popup.add(new JCheckBoxMenuItem("keeping open #2") {
  @Override public void updateUI() {
    super.updateUI();
    setUI(new BasicCheckBoxMenuItemUI() {
      @Override protected void doClick(MenuSelectionManager msm) {
        // super.doClick(msm);
        System.out.println("MenuSelectionManager: doClick");
        menuItem.doClick(0);
      }
    });
  }
});
</code></pre>

## 解説
- `JCheckBox`
    - `JPopupMenu`に`JCheckBox`を追加
    - クリックしてもポップアップは閉じないが、カーソルが乗ってもハイライトされない
- `JMenuItem + JCheckBox`
    - `JCheckBox`を配置したタイトルが空の`JMenuItem`を作成して`JPopupMenu`に追加
    - `JCheckBox`へのマウスイベント(`MOUSE_DRAGGED`, `MOUSE_ENTERED`, `MOUSE_EXITED`, `MOUSE_MOVED`)を親の`JMenuItem`に転送してハイライトを描画
    - `JCheckBox`へのマウスクリックイベント(`MOUSE_CLICKED`, `MOUSE_PRESSED`, `MOUSE_RELEASED`など)はブロックしてポップアップは閉じないように設定
- `JCheckBoxMenuItem`
    - デフォルトの`JCheckBoxMenuItem`で、クリックするとポップアップは閉じる
- `keeping open #1`
    - `JCheckBoxMenuItem`に`Action`を追加して、クリック後にポップアップを再度開くように設定
    - `JPopupMenu`が`JFrame`の外に表示される場合は、ポップアップが一瞬消える
- `keeping open #2`
    - `JCheckBoxMenuItem`に`BasicCheckBoxMenuItemUI#doClick(MenuSelectionManager)`メソッドをオーバーライドした`CheckBoxMenuItemUI`を設定
        - このイベントでクリック後にポップアップを閉じない代わりに、`menuItem.doClick(0);`でチェック状態のみ変更する
        - 参考: [swing - How to prevent JPopUpMenu disappearing when checking checkboxes in it? - Stack Overflow](https://stackoverflow.com/questions/3759379/how-to-prevent-jpopupmenu-disappearing-when-checking-checkboxes-in-it)

<!-- dummy comment line for breaking list -->

- - - -
- `Java 9`では、~~`menuItem.putClientProperty("CheckBoxMenuItem.closeOnMouseClick", false);`~~ `menuItem.putClientProperty("CheckBoxMenuItem.doNotCloseOnMouseClick", true);`などと設定することで、対象の`JCheckBoxMenuItem`をクリックしても親の`JPopupMenu`は閉じなくなる
    - `UIManager.put("CheckBoxMenuItem.doNotCloseOnMouseClick", true)`で全体の`JCheckBoxMenuItem`に適用可能
    - 参考: [JDK-8165234 Provide a way to not close toggle menu items on mouse click on component level - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8165234)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [swing - How to prevent JPopUpMenu disappearing when checking checkboxes in it? - Stack Overflow](https://stackoverflow.com/questions/3759379/how-to-prevent-jpopupmenu-disappearing-when-checking-checkboxes-in-it)

<!-- dummy comment line for breaking list -->

## コメント
