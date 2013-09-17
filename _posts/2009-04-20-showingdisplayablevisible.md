---
layout: post
title: JComponentの表示状態
category: swing
folder: ShowingDisplayableVisible
tags: [JComponent, HierarchyListener, JScrollPane, JTabbedPane, CardLayout]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-04-20

## JComponentの表示状態
`JComponent`の表示状態をテストします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTS-a1ZnQI/AAAAAAAAAjo/jB4n-1WmEIs/s800/ShowingDisplayableVisible.png)

### サンプルコード
<pre class="prettyprint"><code>button.addHierarchyListener(new HierarchyListener() {
  @Override public void hierarchyChanged(HierarchyEvent e) {
    if((e.getChangeFlags() &amp; HierarchyEvent.SHOWING_CHANGED)!=0) {
      printInfo("SHOWING_CHANGED");
    }else if((e.getChangeFlags() &amp; HierarchyEvent.DISPLAYABILITY_CHANGED)!=0) {
      printInfo("DISPLAYABILITY_CHANGED");
    }
  }
});
</code></pre>

### 解説
上記のサンプルでは、コンポーネント(`JButton`)に`HierarchyListener`を追加して、表示状態が切り替わった時の`isDisplayable`、`isShowing`、`isVisible`を調べています。

- 開始時: `HierarchyEvent.DISPLAYABILITY_CHANGED`
    - `isDisplayable`: `true`
    - `isShowing`: `false`
    - `isVisible`: `true`

<!-- dummy comment line for breaking list -->

- `HierarchyEvent.SHOWING_CHANGED`
    - `isDisplayable`: `true`
    - `isShowing`: `true`⇔`false`
    - `isVisible`: `true`

<!-- dummy comment line for breaking list -->

- コンポーネントが`JScrollPane`の表示領域にない、フレームがアイコン化、別パネルの裏に隠れているといった場合
    - `isDisplayable`: `true`
    - `isShowing`: `true`
    - `isVisible`: `true`

<!-- dummy comment line for breaking list -->

- コンポーネントが`JTabbedPane`や`CardLayout`の表示領域にないなど(親コンポーネントが非表示)の場合
    - `isDisplayable`: `true`
    - `isShowing`: `false`
    - `isVisible`: `true`

<!-- dummy comment line for breaking list -->

- コンポーネントが`setVisible(false)`と設定された場合
    - `isDisplayable`: `true`
    - `isShowing`: `false`
    - `isVisible`: `false`

<!-- dummy comment line for breaking list -->

### コメント
