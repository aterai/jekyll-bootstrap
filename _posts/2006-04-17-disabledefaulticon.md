---
layout: post
category: swing
folder: DisableDefaultIcon
title: JFrameのアイコンを非表示
tags: [JFrame, Icon]
author: aterai
pubdate: 2006-04-17T12:43:57+09:00
description: JFrameなどのタイトルバーにあるアイコンを非表示にします。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTK49Ua_nI/AAAAAAAAAWs/Ipb_maWCOgY/s800/DisableDefaultIcon.png
comments: true
---
## 概要
`JFrame`などのタイトルバーにあるアイコンを非表示にします。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTK49Ua_nI/AAAAAAAAAWs/Ipb_maWCOgY/s800/DisableDefaultIcon.png %}

## サンプルコード
<pre class="prettyprint"><code>JFrame frame = new JFrame("test");
MainPanel panel = new MainPanel();
URL url = panel.getClass().getResource("16x16transparent.png");
frame.setIconImage(Toolkit.getDefaultToolkit().createImage(url));
</code></pre>

## 解説
`JFrame#setIconImage(Image)`メソッドを使用してタイトルバーなどに表示されるフレームアイコンを変更しています。

- `null`
    - デフォルトのアイコンが表示される
- `new ImageIcon("").getImage();`
    - `JDK 1.5`では、アイコン非表示、`JDK 1.6`からはデフォルトのアイコンが表示される
    - `Web Start`で起動した場合、`AccessControlException: access denied ("java.io.FilePermission" "" "read")`が発生
- `new BufferedImage(1, 1, BufferedImage.TYPE_INT_ARGB);`
    - サイズが`1x1`で、透明な`Image`を表示
    - タイトルアイコンは非表示でもクリックするとタイトルメニューは開く
    - タスクバーアイコンは黒い矩形になる
- `toolkit.createImage(url_16x16transparent);`
    - 透過色で塗りつぶした`16x16`の`PNG`画像をアイコンとして使用
    - タイトルアイコンは非表示でもクリックするとタイトルメニューは開く
    - タスクバーアイコンは黒い矩形になる

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Swing - Java Default Icon](https://community.oracle.com/thread/1381127)
- [JFrameのIconを変更](https://ateraimemo.com/Swing/FrameIcon.html)
    - タスクバーのアイコンは[Window#setIconImages(List) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Window.html#setIconImages-java.util.List-)で変更する必要がある

<!-- dummy comment line for breaking list -->

## コメント
- thank u -- *mid* 2006-06-15 (木) 17:15:20
    - np -- *aterai* 2009-02-05 (木) 18:10:07
- スクリーンショットなどを更新 -- *aterai* 2009-02-05 (木) 18:15:32

<!-- dummy comment line for breaking list -->
