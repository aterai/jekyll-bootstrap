---
layout: post
category: swing
folder: MenuItemTextAlignment
title: JMenuに追加したJMenuItemなどのテキスト位置を揃える
tags: [JMenuBar, JMenu, JMenuItem, LookAndFeel]
author: aterai
pubdate: 2016-07-18T01:53:49+09:00
description: JMenuに追加したJMenuItemやJLabelなどのコンポーネントのテキスト位置を揃えて表示します。
image: https://lh3.googleusercontent.com/-S49YgtIvzc8/V4upKl0JAFI/AAAAAAAAOd4/9vWtFW4DvY4xR0bL0sM9iGRBvHz_u7AcQCCo/s800/MenuItemTextAlignment.png
comments: true
---
## 概要
`JMenu`に追加した`JMenuItem`や`JLabel`などのコンポーネントのテキスト位置を揃えて表示します。

{% download https://lh3.googleusercontent.com/-S49YgtIvzc8/V4upKl0JAFI/AAAAAAAAOd4/9vWtFW4DvY4xR0bL0sM9iGRBvHz_u7AcQCCo/s800/MenuItemTextAlignment.png %}

## サンプルコード
<pre class="prettyprint"><code>// U+200B zero width space
JMenuItem item3 = new JMenuItem("\u200B"); //, HSTRUT);
// item3.setLayout(new BorderLayout());
// item3.setBorder(BorderFactory.createEmptyBorder()); // NimbusLookAndFeel
item3.setEnabled(false);
// item3.setDisabledIcon(HSTRUT);
item3.add(new JMenuItem("JMenuItem(disabled) with JMenuItem", HSTRUT) {
  @Override public boolean contains(int x, int y) {
    return false; //disable mouse events
  }
});
</code></pre>

## 解説
`JMenu`や`JPopupMenu`にクリック不可の項目として`JMenuItem`の代わりに`JLabel`を追加すると、`WindowsLookAndFeel`を使用している場合や他の`JMenuItem`にアイコンが設定されている場合に、テキストの開始位置が揃わないので、これを回避するために以下の方法をテストしています。

- `JMenuItem.setEnabled(false);`
    - `JMenuItem.setEnabled(false);`と`UIManager.put("MenuItem.disabledForeground", Color.BLACK);`を使用
    - `MenuItem.disabledForeground`が使用されるかどうかは`LookAndFeel`に依存
- `JLabel + EmptyBorder`
    - 余白を設定した`JLabel`を使用
    - 余白の幅は`LookAndFeel`に依存(`LookAndFeel`依存の幅を取得する方法がない？)
- `JPanel with JMenuItem`
    - `MenuElement`ではない透明な`JPanel`に、`JComponent#contains()`メソッドをオーバーライドしてマウスクリックを無効にした`JMenuItem`を追加
- `JMenuItem(disabled) with JMenuItem`
    - `JMenuItem.setEnabled(false);`とした空の`JMenuItem`に、`JComponent#contains()`メソッドをオーバーライドしてマウスクリックを無効にした`JMenuItem`を追加

<!-- dummy comment line for breaking list -->

メモ:
- `JMenu`にアイコン用の余白がない`MetalLookAndFeel`などにアイコンが設定された`JMenuItem`が存在する場合、幅のみのアイコンを設定する必要がある
- `MetalLookAndFeel`の場合、文字列もアイコンも存在しない`JMenuItem`は他の`JMenuItem`と高さが異なる(幅ゼロ空白文字`\u200B`で回避)
- `NimbusLookAndFeel`の`JPanel`は、デフォルトでは背景が不透明

<!-- dummy comment line for breaking list -->

## 参考リンク
- [java - JLabel with icon in JPopupMenu doesn't follow other JMenuItem alignment - Stack Overflow](https://stackoverflow.com/questions/38360595/jlabel-with-icon-in-jpopupmenu-doesnt-follow-other-jmenuitem-alignment)
- [JDK-8152981 Double icons with JMenuItem setHorizontalTextPosition on Win 10 - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8152981)
- [CheckBoxMenuItemのチェックアイコンの位置を調整する](https://ateraimemo.com/Swing/AfterCheckIconGap.html)
    - `Java 8`？では、`CheckBoxMenuItem.afterCheckIconGap`や`CheckBoxMenuItem.minimumTextOffset`などが追加されているため、揃えやすくなった

<!-- dummy comment line for breaking list -->

## コメント
