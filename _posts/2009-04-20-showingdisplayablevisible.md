---
layout: post
category: swing
folder: ShowingDisplayableVisible
title: JComponentの表示状態
tags: [JComponent, HierarchyListener, JScrollPane, JTabbedPane, CardLayout]
author: aterai
pubdate: 2009-04-20T14:24:13+09:00
description: JComponentの表示状態が切り替わった時、そのisDisplayable、isShowing、isVisibleメソッドが返す値をテストします。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTS-a1ZnQI/AAAAAAAAAjo/jB4n-1WmEIs/s800/ShowingDisplayableVisible.png
comments: true
---
## 概要
`JComponent`の表示状態が切り替わった時、その`isDisplayable()`、`isShowing()`、`isVisible()`メソッドが返す値をテストします。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTS-a1ZnQI/AAAAAAAAAjo/jB4n-1WmEIs/s800/ShowingDisplayableVisible.png %}

## サンプルコード
<pre class="prettyprint"><code>button.addHierarchyListener(new HierarchyListener() {
  @Override public void hierarchyChanged(HierarchyEvent e) {
    if ((e.getChangeFlags() &amp; HierarchyEvent.SHOWING_CHANGED) != 0) {
      printInfo("SHOWING_CHANGED");
    } else if ((e.getChangeFlags() &amp; HierarchyEvent.DISPLAYABILITY_CHANGED) != 0) {
      printInfo("DISPLAYABILITY_CHANGED");
    }
  }
});
</code></pre>

## 解説
上記のサンプルでは、コンポーネント(`JButton`)に`HierarchyListener`を追加して、表示状態などが切り替わった時の`isDisplayable`、`isShowing`、`isVisible`メソッドの戻り値を調べています。

- 対象ボタンを作成してパネルに追加した状態で、`frame.setVisible(true)`を実行する前の場合:
    - `isDisplayable`: `false`
    - `isShowing`: `false`
    - `isVisible`: `true`
- `frame.setVisible(true)`後: `HierarchyEvent.DISPLAYABILITY_CHANGED`
    - `isDisplayable`: `true`
    - `isShowing`: `false`
    - `isVisible`: `true`
- `HierarchyEvent.SHOWING_CHANGED`
    - `isDisplayable`: `true`
    - `isShowing`: `true`⇔`false`
    - `isVisible`: `true`
- コンポーネントが`JScrollPane`の表示領域にない、フレームがアイコン化、別パネルの裏に隠れているといった場合:
    - `isDisplayable`: `true`
    - `isShowing`: `true`
    - `isVisible`: `true`
- コンポーネントが親の`JTabbedPane`や`CardLayout`を設定した`JPanel`などの表示領域外(コンポーネントが非表示)の場合:
    - `isDisplayable`: `true`
    - `isShowing`: `false`
    - `isVisible`: `true`
- コンポーネントが`setVisible(false)`と設定された場合:
    - `isDisplayable`: `true`
    - `isShowing`: `false`
    - `isVisible`: `false`

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Component#isDisplayable() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Component.html#isDisplayable--)
- [Component#isShowing() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Component.html#isShowing--)
- [Component#isVisible() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Component.html#isVisible--)

<!-- dummy comment line for breaking list -->

## コメント
