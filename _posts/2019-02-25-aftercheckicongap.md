---
layout: post
category: swing
folder: AfterCheckIconGap
title: CheckBoxMenuItemのチェックアイコンの位置を調整する
tags: [CheckBoxMenuItem, MenuItem, RadioButtonMenuItem]
author: aterai
pubdate: 2019-02-25T17:38:11+09:00
description: CheckBoxMenuItemやRadioButtonMenuItemのチェックアイコンを表示する位置を調整します。
image: https://drive.google.com/uc?id=1aRMouoW3Pw7GiH5nGdLP9r9bK8v_msLABg
comments: true
---
## 概要
`CheckBoxMenuItem`や`RadioButtonMenuItem`のチェックアイコンを表示する位置を調整します。

{% download https://drive.google.com/uc?id=1aRMouoW3Pw7GiH5nGdLP9r9bK8v_msLABg %}

## サンプルコード
<pre class="prettyprint"><code>// UIManager.put("MenuItem.minimumTextOffset", 20 + 20 + 31 - 9);
UIManager.put("CheckBoxMenuItem.afterCheckIconGap", 20);
UIManager.put("CheckBoxMenuItem.checkIconOffset", 20);
</code></pre>


## 解説
上記のサンプルでは、`JCheckBoxMenuItem`の`checkIconOffset`と`afterCheckIconGap`を`20`、`JMenuItem`の`minimumTextOffset`を`62`、その他と`JRadioButtonMenuItem`、`JMenu`は初期値に設定してチェックアイコンの位置をテストしています。

- `checkIconOffset`
    - チェックアイコンの前のオフセット
    - `WindowsLookAndFeel`の初期値は`0`
    - `MetalLookAndFeel`、`NimblsLookAndFeel`の初期値は`null`
    - チェックアイコンの存在しない`JMenuItem`、`JMenu`でも設定可能
- `afterCheckIconGap`
    - チェックアイコンとタイトル文字列との間隔
    - `WindowsLookAndFeel`の初期値は`9`
    - `MetalLookAndFeel`、`NimblsLookAndFeel`の初期値は`null`
    - チェックアイコンの存在しない`JMenuItem`、`JMenu`でも設定可能
- `minimumTextOffset`
    - メニューのタイトル文字列までのオフセット
    - `WindowsLookAndFeel`の初期値は`31`(チェックアイコンのサイズは`22`？)
    - `MetalLookAndFeel`、`NimblsLookAndFeel`の初期値は`null`
    - この値が`checkIconOffset`と`afterCheckIconGap`の合計より大きくなる場合、`afterCheckIconGap`の指定が無視されて拡大する

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JMenuに追加したJMenuItemなどのテキスト位置を揃える](https://ateraimemo.com/Swing/MenuItemTextAlignment.html)

<!-- dummy comment line for breaking list -->

## コメント
